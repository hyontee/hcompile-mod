stock GetAccessoriesItem ( modelId )
{
	if ( GetString ( get_accessorie_name ( modelId ), "Unknown" ) ) return false ;
	return true ;
}

stock NotPreLoadAccessories ( modelId )
{
	if ( modelId == ITEM_SIM_CARD ) return false ;
	else if ( weapon_skins ( modelId ) ) return false ;
	return true ;
}

stock save_accesories ( playerid, idx )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 456, "UPDATE `users_accessories_float` SET `acs_position` = '%.4f|%.4f|%.4f|%.4f|%.4f|%.4f' WHERE `id` = '%d' LIMIT 1",
	GetUserAccessories ( playerid, ACS_OBJ_X, idx ), GetUserAccessories ( playerid, ACS_OBJ_Y, idx ), GetUserAccessories ( playerid, ACS_OBJ_Z, idx ),
	GetUserAccessories ( playerid, ACS_ROT_X, idx ), GetUserAccessories ( playerid, ACS_ROT_Y, idx ), GetUserAccessories ( playerid, ACS_ROT_Z, idx ),
	GetUserAccessories ( playerid, ACS_ID, idx ) ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

stock insertAccessoriesFloat ( acsId )
{
	static const _str [ ] = "INSERT INTO `users_accessories_float` (`id`) VALUES ('%d')" ;
	new _query [ sizeof _str + 9 ] ;
	format ( _query, sizeof _query, _str, acsId ) ;
	mysql_tquery ( sql_connection, _query ) ;
	return true ;
}

stock insertAccessoriesStats ( acsId, maxWear )
{
	static const _str [ ] = "INSERT INTO `users_accessories_stats` (`id`,`acs_wear`) VALUES ('%d','%d')" ;
	new _query [ sizeof _str + 9 ] ;
	format ( _query, sizeof _query, _str, acsId, maxWear ) ;
	mysql_tquery ( sql_connection, _query ) ;
	return true ;
}

stock deleteAccessoriesFloat ( acsId )
{
	static const _str [ ] = "DELETE FROM `users_accessories_float` WHERE `id` = %d LIMIT 1" ;
	new _query [ sizeof _str + 9 ] ;
	format ( _query, sizeof _query, _str, acsId ) ;
	mysql_tquery ( sql_connection, _query ) ;
	return true ;
}

stock deleteAccessoriesStats ( acsId )
{
	static const _str [ ] = "DELETE FROM `users_accessories_stats` WHERE `id` = %d LIMIT 1" ;
	new _query [ sizeof _str + 9 ] ;
	format ( _query, sizeof _query, _str, acsId ) ;
	mysql_tquery ( sql_connection, _query ) ;
	return true ;
}

stock get_accessorie_name ( modelid )
{
	new model_name [ 28 ] ;
	switch ( modelid )
	{
		case 18947:strcat ( model_name, "Чёрная шляпа" ) ;
		case 18948:strcat ( model_name, "Синяя шляпа" ) ;
		case 18949:strcat ( model_name, "Зелёная шляпа" ) ;
		case 18950:strcat ( model_name, "Красная шляпа" ) ;
		case 18951:strcat ( model_name, "Жёлтая шляпа" ) ;
		case 18970:strcat ( model_name, "Тигровая шляпа" ) ;
		case 18973:strcat ( model_name, "Леопардовая шляпа" ) ;
		case 18972:strcat ( model_name, "Жёлто-чёрная шляпа" ) ;
		case 18971:strcat ( model_name, "Чёрно-белая шляпа" ) ;
		case 19421:strcat ( model_name, "Серые наушники" ) ;
		case 19422:strcat ( model_name, "Чёрные наушники" ) ;
		case 18910:strcat ( model_name, "Бандана цвета лавы" ) ;
		case 18909:strcat ( model_name, "Бандана цвета воды" ) ;
		case 18908:strcat ( model_name, "Бандана с синими узорами" ) ;
		case 18907:strcat ( model_name, "Бандана разноцветная" ) ;
		case 18906:strcat ( model_name, "Серо-красная бандана" ) ;
		case 19423:strcat ( model_name, "Красные наушники" ) ;
		case 19424:strcat ( model_name, "Синие наушники" ) ;
		case 19069:strcat ( model_name, "Серо-чёрная шапка" ) ;
		case 19519:strcat ( model_name, "Серый парик" ) ;
		case 19274:strcat ( model_name, "Красный парик" ) ;
		case 19068:strcat ( model_name, "Серо-чёрная шапка с узором" ) ;
		case 19104:strcat ( model_name, "Шлем цвета хаки с затяжками" ) ;
		case 19105:strcat ( model_name, "Армейский шлем с затяжками" ) ;
		case 19106:strcat ( model_name, "Армейский шлем" ) ;
		case 19107:strcat ( model_name, "Тусклый армейский шлем" ) ;
		case 19108:strcat ( model_name, "Армейский шлем цвета хаки" ) ;
		case 19109:strcat ( model_name, "Яркий армейский шлем" ) ;
		case 19067:strcat ( model_name, "Красно-чёрная шапка" ) ;
		case 19554:strcat ( model_name, "Серый берет" ) ;
		case 18953:strcat ( model_name, "Чёрная шапка в полоску" ) ;
		case 18954:strcat ( model_name, "Серая шапка в полоску" ) ;
		case 18968:strcat ( model_name, "Сине-серая панамка" ) ;
		case 18967:strcat ( model_name, "Чёрная панамка" ) ;
		case 18969:strcat ( model_name, "Серо-красная панамка" ) ;
		case 18955:strcat ( model_name, "Серо-красная кепка" ) ;
		case 18956:strcat ( model_name, "Серо-красная кепка" ) ;
		case 18957:strcat ( model_name, "Синяя кепка с узором" ) ;
		case 18959:strcat ( model_name, "Армейская кепка"  ) ;
		case 18926:strcat ( model_name, "Кепка цвета хаки"  ) ;
		case 18927:strcat ( model_name, "Синяя кепка с узором" ) ;
		case 18928:strcat ( model_name, "Цветная кепка" ) ;
		case 18929:strcat ( model_name, "Серая кепка с узором" ) ;
		case 18930:strcat ( model_name, "Кепка цвета лавы" ) ;
		case 18932:strcat ( model_name, "Серо-красная кепка" ) ;
		case 18933:strcat ( model_name, "Белая кепка с узором" ) ;
		case 18911:strcat ( model_name, "Чёрная маска" ) ;
		case 18912:strcat ( model_name, "Чёрная маска с узором" ) ;
		case 18913:strcat ( model_name, "Зелёная маска с узором" ) ;
		case 18914:strcat ( model_name, "Армейская маска" ) ;
		case 18915:strcat ( model_name, "Розовая маска с узором" ) ;
		case 18916:strcat ( model_name, "Цветная маска" ) ;
		case 18917:strcat ( model_name, "Маска с изображением молнии" ) ;
		case 18918:strcat ( model_name, "Серая маска с узором" ) ;
		case 18919:strcat ( model_name, "Белая маска с узором" ) ;
		case 18920:strcat ( model_name, "Жёлто-коричневая маска" ) ;
		case 18925:strcat ( model_name, "Красный берет" ) ;
		case 19011:strcat ( model_name, "Очки с изображением спирали" ) ;
		case 19012:strcat ( model_name, "Чёрные очки" ) ;
		case 19013:strcat ( model_name, "Очки с изображением глаз" ) ;
		case 19014:strcat ( model_name, "Очки «Deal with it»" ) ;
		case 19015:strcat ( model_name, "Очки без линз" ) ;
		case 19016:strcat ( model_name, "Очки «X-RAY VISION»" ) ;
		case 19017:strcat ( model_name, "Жёлтые очки" ) ;
		case 19018:strcat ( model_name, "Оранжевые очки" ) ;
		case 19019:strcat ( model_name, "Красные очки" ) ;
		case 19024:strcat ( model_name, "Очки с фиолетовыми линзами" ) ;
		case 19027:strcat ( model_name, "Очки с оранжевыми линзами" ) ;
		case 19028:strcat ( model_name, "Очки с жёлтыми линзами" ) ;
		case 19029:strcat ( model_name, "Очки с зелёными линзами" ) ;
		case 19022:strcat ( model_name, "Очки с серыми линзами" ) ;
		case 19035:strcat ( model_name, "Очки с синими линзами" ) ;
		case 19031:strcat ( model_name, "Очки с ярко-жёлтыми линзами" ) ;
		case 19032:strcat ( model_name, "Очки с красными линзами" ) ;
		case 19033:strcat ( model_name, "Очки с чёрными линзами" ) ;
		case 19042:strcat ( model_name, "Золотые часы" ) ;
		case 19041:strcat ( model_name, "Бронзовые часы" ) ;
		case 19040:strcat ( model_name, "Серебряные часы" ) ;
		case 19039:strcat ( model_name, "Золотые часы" ) ;
		case 19043:strcat ( model_name, "Серебряные часы" ) ;
		case 19044:strcat ( model_name, "Розовые часы" ) ;
		case 19045:strcat ( model_name, "Красные часы" ) ;
		case 19046:strcat ( model_name, "Зелёные часы" ) ;
		case 19048:strcat ( model_name, "Синие часы" ) ;
		case 19049:strcat ( model_name, "Цветные часы" ) ;
		case 19050:strcat ( model_name, "Синие часы с узором" ) ;
		case 19051:strcat ( model_name, "Жёлто-чёрные часы" ) ;
		case 19053:strcat ( model_name, "Часы из змеиной кожи" ) ;
		case 18931:strcat ( model_name, "Черно-синяя кепка" ) ;
		case 3026:strcat ( model_name, "Чёрный рюкзак" ) ;
		case 371:strcat ( model_name, "Рюкзак" ) ;
		case 19559:strcat ( model_name, "Походный рюкзак" ) ;
		case 19319:strcat ( model_name, "Чёрная гитара" ) ;
		case 19318:strcat ( model_name, "Белая гитара" ) ;
		case 19317:strcat ( model_name, "Красная гитара" ) ;
		case 19472:strcat ( model_name, "Респиратор" ) ;
		case 19142:strcat ( model_name, "Бронежилет" ) ;
		case 1276:strcat ( model_name, "Амулет" ) ;
		case 19079:strcat ( model_name, "Попугай" ) ;
		case 19137:strcat ( model_name, "Маска петуха" ) ;
		case 18637:strcat ( model_name, "Щит" ) ;
		case 19036:strcat ( model_name, "Белая маска" ) ;
		case 19037:strcat ( model_name, "Красная маска" ) ;
		case 19038:strcat ( model_name, "Зелёная маска" ) ;
		case 18938:strcat ( model_name, "Синяя каска" ) ;
		case 18937:strcat ( model_name, "Красная каска" ) ;
		case 19118:strcat ( model_name, "Зелёная каска" ) ;
		case 19469:strcat ( model_name, "Повязка" ) ;
		case 19094:strcat ( model_name, "Шапка Burger Shot" ) ;
		case 19314:strcat ( model_name, "Рога" ) ;
		case 19332:strcat ( model_name, "Воздушный шар" ) ;
		case 19333:strcat ( model_name, "Воздушный шар" ) ;
		case 19334:strcat ( model_name, "Воздушный шар" ) ;
		case 19335:strcat ( model_name, "Воздушный шар" ) ;
		case 19336:strcat ( model_name, "Воздушный шар" ) ;
		case 19337:strcat ( model_name, "Воздушный шар" ) ;
		case 19338:strcat ( model_name, "Воздушный шар" ) ;
		case 8492:strcat ( model_name, "Крылья" ) ;
		case 2511:strcat ( model_name, "Самолётик" ) ;
		case 11712:strcat ( model_name, "Крест" ) ;
		case 19197:strcat ( model_name, "Ангельский нимб" ) ;
		case 11704:strcat ( model_name, "Голова дьявола" ) ;
		case 19904:strcat ( model_name, "Рабочий жилет" ) ;
		case 1083:strcat ( model_name, "BMX" ) ;
		
		// Матрешка
		case 14100:strcat ( model_name, "Очки #1" ) ;
		case 14101:strcat ( model_name, "Очки #2" ) ;
		case 14102:strcat ( model_name, "Очки #3" ) ;
		case 14103:strcat ( model_name, "Очки #4" ) ;
		case 14104:strcat ( model_name, "Очки #5" ) ;
		case 14105:strcat ( model_name, "Браслет Supreme (R)" ) ;
		case 14106:strcat ( model_name, "Браслет Gucci" ) ;
		case 14107:strcat ( model_name, "Браслет Balenciaga" ) ;
		case 14108:strcat ( model_name, "Браслет Chanel" ) ;
		case 14109:strcat ( model_name, "Браслет Supreme (B)" ) ;
		case 14110:strcat ( model_name, "Кепка NY" ) ;
		case 14111:strcat ( model_name, "Кепка Palms Angels" ) ;
		case 14112:strcat ( model_name, "Кепка DSQUARED (R)" ) ;
		case 14113:strcat ( model_name, "Кепка DSQUARED (B)" ) ;
		case 14114:strcat ( model_name, "Кепка MARC O POLO" ) ;
		case 14115:strcat ( model_name, "Кепка North Face" ) ;
		case 14116:strcat ( model_name, "Кепка Shit" ) ;
		case 14117:strcat ( model_name, "Кепка Adidas" ) ;
		case 14118:strcat ( model_name, "Кепка Nike" ) ;
		case 14119:strcat ( model_name, "Кепка Mercedes" ) ; // case mercedes
		case 14120:strcat ( model_name, "Кепка BMW" ) ; // case bmw
		case 14121:strcat ( model_name, "Рюкзак CREVIS (Y)" ) ;
		case 14122:strcat ( model_name, "Рюкзак CREVIS (B)" ) ;
		case 14123:strcat ( model_name, "Рюкзак CREVIS (G)" ) ;
		case 14124:strcat ( model_name, "Рюкзак CREVIS (WBlue)" ) ;
		case 14125:strcat ( model_name, "Рюкзак CREVIS (WBlack)" ) ;
		case 14126:strcat ( model_name, "Рюкзак CREVIS (Череп)" ) ;
		case 14395:strcat ( model_name, "Хиджаб (Синий)" ) ; // case major + donate
		case 14396:strcat ( model_name, "Хиджаб (Gucci)" ) ; // case major + donate
		case 14397:strcat ( model_name, "Хиджаб (Louis Vuitton)" ) ; // donate
		case 14398:strcat ( model_name, "Рюкзак (Gold)" ) ; // containers
		case 14399:strcat ( model_name, "Рюкзак (WhiteAndBlack)" ) ; // containers
		case 14400:strcat ( model_name, "Рюкзак (GreyAndBlack)" ) ; // containers
		case 14401:strcat ( model_name, "Сумочка Gucci" ) ;
		case 14402:strcat ( model_name, "Сумочка Gucci #2" ) ;
		case 14403:strcat ( model_name, "Рюкзак Tiger" ) ; // промо
		case 14404:strcat ( model_name, "Ранец (Louis Vuitton)" ) ;
		case 14405:strcat ( model_name, "Рюкзак Mike" ) ;
		case 14406:strcat ( model_name, "Рюкзак Kitty" ) ;
		case 14407:strcat ( model_name, "Рюкзак Flowers" ) ;
		case 14423:strcat ( model_name, "Очки Orange" ) ;
		case 14424:strcat ( model_name, "Очки Oculus" ) ;
		case 14425:strcat ( model_name, "Очки Leps" ) ;
		case 14426:strcat ( model_name, "Очки Heart" ) ;
		case 14427:strcat ( model_name, "Очки Green Heart" ) ;
		case 14428:strcat ( model_name, "Маска чёрная с зубами" ) ;
		case 14429:strcat ( model_name, "Маска пятнистая с зубами" ) ;
		case 14430:strcat ( model_name, "Маска розовая с зубами" ) ;
		case 14431:strcat ( model_name, "Маска фиолет с зубами" ) ;
		case 14432:strcat ( model_name, "Маска пб (Зелёная)" ) ;
		case 14433:strcat ( model_name, "Маска зелёная с зубами" ) ;
		case 14434:strcat ( model_name, "Маска пб (Чёрная)" ) ;
		case 14435:strcat ( model_name, "Маска пб (Чёрно-розовая)" ) ;
		case 14436:strcat ( model_name, "Маска пб (Чёрно-жёлтая)" ) ;
		case 14437:strcat ( model_name, "Маска пб (Чёрно-голубая)" ) ;
		case 14438:strcat ( model_name, "Маска М белая" ) ;
		case 14439:strcat ( model_name, "Маска М чёрная" ) ;
		
		case 11755:strcat ( model_name, "Ghost" ) ;
		case 11756:strcat ( model_name, "Joker" ) ;
		case 11757:strcat ( model_name, "Маска (Red mouth)" ) ;
		case 11758:strcat ( model_name, "Маска (Череп Red)" ) ;
		case 11759:strcat ( model_name, "Балаклава (Red)" ) ;
		case 11760:strcat ( model_name, "Пивная кепка" ) ;
		case 11761:strcat ( model_name, "Anonymus" ) ;
		case 11763:strcat ( model_name, "Гитара-топор" ) ;
		case 11764:strcat ( model_name, "Hello-Kitty (блест.)" ) ;
		case 11765:strcat ( model_name, "Kaneki" ) ;
		case 11766:strcat ( model_name, "Тигр на плече" ) ;
		case 11767:strcat ( model_name, "Marshmallow" ) ;
		case 11768:strcat ( model_name, "Pikachu" ) ;
		case 11769:strcat ( model_name, "Samurai" ) ;
		case 11770:strcat ( model_name, "Shrek" ) ;
		case 11771:strcat ( model_name, "Балаклава (Black)" ) ;
		case 11773:strcat ( model_name, "Бананка (Красная)" ) ;
		case 11774:strcat ( model_name, "Бананка (Красная)" ) ;
		case 11775:strcat ( model_name, "Бананка (Синяя)" ) ;
		case 11776:strcat ( model_name, "Бананка (Голубая)" ) ;
		case 11777:strcat ( model_name, "Бананка (Серая)" ) ;
		case 11778:strcat ( model_name, "Бананка (Зеленая)" ) ;
		case 11779:strcat ( model_name, "Бананка (Белая)" ) ;
		case 11781:strcat ( model_name, "Бронежилет (1 ур.)" ) ;
		case 11782:strcat ( model_name, "Бронежилет (2 ур.)" ) ;
		case 11783:strcat ( model_name, "Бронежилет (3 ур.)" ) ;
		case 14050:strcat ( model_name, "Шапка (Черная)" ) ;
		case 14051:strcat ( model_name, "Шапка (Коричневая)" ) ;
		case 14052:strcat ( model_name, "Шапка (Серая)" ) ;
		case 14053:strcat ( model_name, "Шапка (Голубая)" ) ;
		case 14054:strcat ( model_name, "Шапка (Розовая)" ) ;
		case 14055:strcat ( model_name, "Шапка (Фиолетовая)" ) ;
		case 14056:strcat ( model_name, "Шапка г. (Черная)" ) ;
		case 14057:strcat ( model_name, "Шапка г. (Коричневая)" ) ;
		case 14058:strcat ( model_name, "Шапка г. (Бежевая)" ) ;
		case 14059:strcat ( model_name, "Шапка г. (Раста)" ) ;
		case 14060:strcat ( model_name, "Шапка г. (Полоска)" ) ;
		case 14061:strcat ( model_name, "Шапка г. (Россия)" ) ;
		case 14062:strcat ( model_name, "Шапка г. (Эмблема)" ) ;
		case 14063:strcat ( model_name, "Шарф (Бежевый)" ) ;
		case 14064:strcat ( model_name, "Шарф (Серый)" ) ;
		case 14065:strcat ( model_name, "Шарф (Черный)" ) ;
		case 14066:strcat ( model_name, "Шарф (Синий)" ) ;
		case 14067:strcat ( model_name, "Шарф (Красный)" ) ;
		case 14068:strcat ( model_name, "Шарф (Зеленый)" ) ;
		case 14069:strcat ( model_name, "Шарф вяз. (Коричневый)" ) ;
		case 14070:strcat ( model_name, "Шарф вяз. (Хаки)" ) ;
		case 14071:strcat ( model_name, "Шарф вяз. (Черный)" ) ;
		case 14072:strcat ( model_name, "Шарф вяз. (Белый)" ) ;
		case 14073:strcat ( model_name, "Шапка-Beer (Син.)" ) ;
		case 14074:strcat ( model_name, "Шапка с помпоном (Син.)" ) ;
		case 14075:strcat ( model_name, "Шапка с помпоном (Сер.)" ) ;
		case 14076:strcat ( model_name, "Шапка с помпоном (Бел.)" ) ;
		case 14077:strcat ( model_name, "Шапка с помпоном (Зел.)" ) ;
		case 14078:strcat ( model_name, "Шапка с помпоном (Беж.)" ) ;
		case 14079:strcat ( model_name, "Шапка вяз. (Белая)" ) ;
		case 14080:strcat ( model_name, "Шапка вяз. (Хиппи)" ) ;
		case 14081:strcat ( model_name, "Шапка вяз. (Черная)" ) ;
		case 14082:strcat ( model_name, "Шапка вяз. (Оранжевая)" ) ;
		case 14083:strcat ( model_name, "Шапка вяз. (Фиолетовая)" ) ;
		case 14084:strcat ( model_name, "Шапка ушанка (Кор.)" ) ;
		case 14085:strcat ( model_name, "Шапка ушанка (Зел.)" ) ;
		case 14086:strcat ( model_name, "Шапка ушанка (Кр.)" ) ;
		case 14087:strcat ( model_name, "Шапка ушанка (Зел. ярк.)" ) ;
		case 14088:strcat ( model_name, "Шапка ушанка (Сер.)" ) ;
		case 14089:strcat ( model_name, "Шапка-медведь (ч-б)" ) ;
		case 14090:strcat ( model_name, "Шапка-медведь (б-к)" ) ;
		case 14091:strcat ( model_name, "Шапка-медведь (б-з)" ) ;
		case 14092:strcat ( model_name, "Шапка-медведь (б-ф)" ) ;
		case 14093:strcat ( model_name, "Шапка-медведь (б-о)" ) ;
		case 14094:strcat ( model_name, "Шапка-Beer (Фиол.)" ) ;
		case 14133:strcat ( model_name, "Шапка-Beer (Зеленая)" ) ;
		case 14134:strcat ( model_name, "Шапка-Beer (Черная)" ) ;
		case 14135:strcat ( model_name, "Шарф (Белый)" ) ;
		case 14136:strcat ( model_name, "Шарф (Бежевый)" ) ;
		case 14137:strcat ( model_name, "Шарф (Коричневый)" ) ;
		case 14138:strcat ( model_name, "Шарф (Красный)" ) ;
		case 14139:strcat ( model_name, "Шарф (Синий)" ) ;
		case 14140:strcat ( model_name, "Шарф кл. (Жёлтый)" ) ;
		case 14141:strcat ( model_name, "Шарф кл. (Красный)" ) ;
		case 14142:strcat ( model_name, "Шарф кл. (Белый)" ) ;
		case 14143:strcat ( model_name, "Шарф кл. (Олени)" ) ;
		case 14144:strcat ( model_name, "Шарф кл. (Голубой)" ) ;
		case 14145:strcat ( model_name, "Рюкзак олень (бел.)" ) ;
		case 14146:strcat ( model_name, "Рюкзак олень (фиол.)" ) ;
		case 14147:strcat ( model_name, "Рюкзак олень (зел.)" ) ;
		case 14148:strcat ( model_name, "Рюкзак олень (роз.)" ) ;
		case 14150:strcat ( model_name, "Рога (кр.)" ) ;
		case 14151:strcat ( model_name, "Рога (фиол.)" ) ;
		case 14152:strcat ( model_name, "Рога (син.)" ) ;
		case 14153:strcat ( model_name, "Рога (зел.)" ) ;
		case 14154:strcat ( model_name, "Рога (оран.)" ) ;
		case 14155:strcat ( model_name, "Покер (бел.)" ) ;
		case 14156:strcat ( model_name, "Покер (кр.)" ) ;
		case 14157:strcat ( model_name, "Покер (беж.)" ) ;
		case 14158:strcat ( model_name, "Покер (звезды)" ) ;
		case 14159:strcat ( model_name, "Покер (клетка)" ) ;
		case 14160:strcat ( model_name, "Ворот (белый)" ) ;
		case 14161:strcat ( model_name, "Ворот (красный)" ) ;
		case 14162:strcat ( model_name, "Ворот (клетка)" ) ;
		case 14163:strcat ( model_name, "Ворот (звезды)" ) ;
		case 14164:strcat ( model_name, "Ворот (серый)" ) ;
		case 14165:strcat ( model_name, "Шапка вяз. пом. (бел.)" ) ;
		case 14166:strcat ( model_name, "Шапка вяз. пом. (кр.)" ) ;
		case 14167:strcat ( model_name, "Шапка вяз. пом. (чер.)" ) ;
		case 14168:strcat ( model_name, "Шапка вяз. пом. (leafs)" ) ;
		case 14169:strcat ( model_name, "Шапка вяз. пом. (зел.)" ) ;

		// Русь
		case 12100: strcat ( model_name, "Сумка Dolce" ) ; // Левая рука
		case 12101: strcat ( model_name, "Кожаная сумка" ) ; // Левая рука
		case 12102: strcat ( model_name, "Красная сумка" ) ; // Левая рука
		case 12103: strcat ( model_name, "Сумка Horse" ) ; // Левая рука
		case 12104: strcat ( model_name, "Розовая сумка" ) ; // Левая рука
		case 12105: strcat ( model_name, "Рюкзак #1" ) ; // Спина
		case 12106: strcat ( model_name, "Рюкзак #2" ) ; // Спина
		case 12107: strcat ( model_name, "Рюкзак #3" ) ; // Спина
		case 12108: strcat ( model_name, "Рюкзак #4" ) ; // Спина
		case 12109: strcat ( model_name, "Кепка #1" ) ; // Голова
		case 12110: strcat ( model_name, "Кепка #2" ) ; // Голова
		case 12111: strcat ( model_name, "Кепка #3" ) ; // Голова
		case 12112: strcat ( model_name, "Гитара #1" ) ; // Спина
		case 12113: strcat ( model_name, "Гитара #2" ) ; // Спина
		case 12114: strcat ( model_name, "Гитара #3" ) ; // Спина
		case 12115: strcat ( model_name, "Маска #1" ) ; // Голова
		case 12116: strcat ( model_name, "Маска #2" ) ; // Голова
		case 12117: strcat ( model_name, "Маска #3" ) ; // Голова
		case 12118: strcat ( model_name, "Маска #4" ) ; // Голова
		case 12119: strcat ( model_name, "Маска #5" ) ; // Голова
		case 12120: strcat ( model_name, "Маска #6" ) ; // Голова
		case 12121: strcat ( model_name, "Маска #7" ) ; // Голова
		case 12122: strcat ( model_name, "Маска #8" ) ; // Голова
		case 12123: strcat ( model_name, "Маска #9" ) ; // Голова
		case 12124: strcat ( model_name, "Маска #10" ) ; // Голова
		case 12125: strcat ( model_name, "Маска #11" ) ; // Голова
		case 12126: strcat ( model_name, "Маска #12" ) ; // Голова
		case 12127: strcat ( model_name, "Маска #13" ) ; // Голова
		case 12128: strcat ( model_name, "Маска #14" ) ; // Голова
		case 12129: strcat ( model_name, "Маска #15" ) ; // Голова
		case 12130: strcat ( model_name, "Маска #16" ) ; // Голова
		case 12131: strcat ( model_name, "Маска #17" ) ; // Голова
		case 12132: strcat ( model_name, "Маска #18" ) ; // Голова
		case 12133: strcat ( model_name, "Маска #19" ) ; // Голова
		case 12134: strcat ( model_name, "Маска #20" ) ; // Голова
		case 12135: strcat ( model_name, "Рюкзак #5" ) ; // Спина
		case 12136: strcat ( model_name, "Рюкзак #6" ) ; // Спина
		case 12137: strcat ( model_name, "Нимб" ) ; // Голова
		case 12138: strcat ( model_name, "Рюкзак #7" ) ; // Спина
		case 12139: strcat ( model_name, "Бластер" ) ;
		case 12140: strcat ( model_name, "Рюкзак #8" ) ; // Спина
		case 12142: strcat ( model_name, "Маска #21" ) ; // Голова
		case 12143: strcat ( model_name, "Крипер" ) ;
		case 12144: strcat ( model_name, "Маска демона" ) ; // Голова - donate
		case 12145: strcat ( model_name, "Шляпа #1" ) ; // Голова
		case 12146: strcat ( model_name, "El Primo" ) ;
		case 12147: strcat ( model_name, "Нож" ) ;
		case 12148: strcat ( model_name, "Шляпа #2" ) ; // Голова
		case 12149: strcat ( model_name, "Маска #22" ) ; // Голова
		case 12150: strcat ( model_name, "Маска #23" ) ; // Голова
		case 12151: strcat ( model_name, "Рога демона" ) ; // Голова - donate
		case 12152: strcat ( model_name, "Крылья демона" ) ; // Спина - donate
		case 12153: strcat ( model_name, "Крылья на спину #1" ) ; // Спина - donate
		case 12154: strcat ( model_name, "Крылья на спину #2" ) ; // Спина - donate
		case 12155: strcat ( model_name, "Крылья на спину #3" ) ; // Спина - donate
		case 12156: strcat ( model_name, "Кепка любителя БМВ" ) ; // Спина
		case 12157: strcat ( model_name, "Пряня" ) ; // gold roulette
		case 12158: strcat ( model_name, "Маска Мяча" ) ; // Голова
		case 12159: strcat ( model_name, "Кепка Playboy" ) ; // Голова - donate
		case 12160: strcat ( model_name, "Рюкзак Pele" ) ; // Спина
		case 12161: strcat ( model_name, "Ушки Playboy" ) ; // Голова - donate

		// weapon skins
		case 3500: model_name = "AWP Silver" ; // donate case
		case 3501: model_name = "AWP Red" ; // donate case
		case 3502: model_name = "AWP Anime" ; // craft
		case 3503: model_name = "Gold AK-47" ; // donate case
		case 3504: model_name = "Dragon AK-47" ; // donate case
		case 3505: model_name = "Blue AK-47" ;
		case 3506: model_name = "Impulse AK-47" ;
		case 3507: model_name = "Blood Rifle" ; // donate case
		case 3508: model_name = "Silver Rifle" ; // gold roulette
		case 3509: model_name = "Energy Rifle" ; // free case
		case 3510: model_name = "White AK-74" ; // craft
		case 3511: model_name = "CS AK-74" ; // donate case
		case 3512: model_name = "Flower Mak" ;
		case 3513: model_name = "CS Mak" ; // donate case
		case 3514: model_name = "Death Mak" ; // craft
		case 3515: model_name = "Eye Dragon" ; // donate case
		case 3516: model_name = "Impulse ShotGun" ;
		case 3517: model_name = "Rainbow ShotGun" ;
		case 3518: model_name = "Dragon ShotGun" ; // donate case
		case 3519: model_name = "Teeth ShotGun" ;
		case 3520: model_name = "Snow UMP" ;
		case 3521: model_name = "Red arrow UMP" ;
		case 3522: model_name = "Dice UMP" ;
		case 3523: model_name = "Monster UMP" ;
		case ITEM_SIM_CARD: model_name = "SIM-карта" ;

		default: model_name = "Unknown" ;
	}
	return model_name ;
}

stock ResetAccessoriesStats ( playerid )
{
	new acsLevel, modelId, weapId ;
	for ( new slotId = 0 ; slotId < MAX_ACCESORIES ; slotId ++ )
	{
		acsLevel = GetUserAccessories ( playerid, ACS_LEVEL, slotId ) ;
		modelId = GetUserAccessories ( playerid, ACS_MODEL, slotId ) ;
		
		for ( new i = 0 ; i < ACS_STATS_SPECIAL ; i ++ )
		{
			if ( GetModelStatsLevel ( i, modelId, acsLevel ) > 0 )
				GetPlayerTimeAcsInfo ( playerid, PT_ACS_STATS, i ) += GetModelStatsInfo ( i, modelId, acsLevel ) ;

			if ( GetModelStatsLevel ( ACS_STATS_WEAPON, modelId, i ) > 0 )
			{
				weapId = GetModelStatsLevel ( ACS_STATS_WEAPON, modelId, i ) ;
				GetPlayerTimeAcsInfo ( playerid, PT_ACS_WEAPON_STATS, weapId ) = GetModelStatsInfo ( ACS_STATS_WEAPON, modelId, i ) ;
			}
		}
	}
	return true ;
}

stock attachUserAccessories ( playerid, slotId = INVALID_PLAYER_ID )
{
	if ( slotId != INVALID_PLAYER_ID )
	{
		putOnAccessories ( playerid, GetUserAccessories ( playerid, ACS_MODEL, slotId ) ) ;
	}
	else
	{
		for ( new j = 0 ; j < MAX_ACCESORIES ; j ++ )
		{
			if ( GetUserAccessories ( playerid, ACS_USED, j ) == 0 ) continue ;
			putOnAccessories ( playerid, GetUserAccessories ( playerid, ACS_MODEL, j ) ) ;
		}
	}
	GetPlayerTimeInfo ( playerid, PT_ACS_WEAPON_STATS ) = PlayerTimeInfoClearSlot ;
	GetPlayerTimeInfo ( playerid, PT_ACS_STATS ) = PlayerTimeInfoAcsStats ;
	ResetAccessoriesStats ( playerid ) ;
	return true ;
}

stock skinShopAccessories ( playerid, modelId )
{
	return putOnAccessories ( playerid, modelId ) ;
}

stock putOnAccessories ( playerid, item )
{
	new skinid = GetPlayerSkin ( playerid ) ;
	switch ( item )
	{
		// Левая рука
		case 12100, 12101, 12102, 12103, 12104:
		{
			SetAttachToSkin ( playerid, 151, skinid, item ) ;
		}

		// Спина
		case 12105, 12106, 12107, 12108, 12112, 12113, 12114,
		12135, 12136, 12138, 12140, 12152, 12153, 12154, 12155, 12160:
		{
			SetAttachToSkin ( playerid, 151, skinid, item ) ;
		}

		// Голова
		case 12109, 12110, 12111, 12115, 12116, 12117, 12118, 12119, 12120, 12121, 12122, 12123,
		12124, 12125, 12126, 12127, 12128, 12129, 12130, 12131, 12132, 12133, 12134, 12137, 12142,
		12144, 12145, 12148, 12149, 12150, 12151, 12156, 12158, 12159, 12161:
		{
			SetAttachToSkin ( playerid, 151, skinid, item ) ;
		}

		// update november 2022
		case 11755, 11756, 11757, 11758, 11759, 11760, 11761, 11765, 11767, 11768, 11769, 11770, 11771, 14050..14055,
			14056..14062, 14073, 14094, 14133, 14134, 14074..14078, 14079..14083, 14084..14088, 14089..14093, 14150..14154,
			14155..14159, 14160..14164, 14165..14169: // голова
		{
			SetAttachToSkin(playerid, 147, skinid, item ) ;
		}
		case 11763, 11764, 11773..11779, 14063..14068, 14069..14072, 14135..14139, 14140..14144, 14145..14148: // Рюкзаки
		{
			SetAttachToSkin(playerid, 148, skinid, item ) ;
		}
		case 11781, 11782, 11783: // Жилеты
		{
			SetAttachToSkin(playerid, 149, skinid, item ) ;
		}
		case 11762, 11766, 11780: // плечо
		{
			SetAttachToSkin(playerid, 150, skinid, item ) ;
		}
		
		case 14423, 14424, 14425, 14426, 14427: // Очки (Матрешка)
		{
			SetAttachToSkin(playerid, 122, skinid, item ) ;
		}
		case 14432, 14434, 14435, 14436, 14437: // Маски
		{
			SetAttachToSkin(playerid, 121, skinid, item ) ;
		}
		case 14428, 14429, 14430, 14431, 14433, 14438, 14439: // Маски
		{
			SetAttachToSkin(playerid, 120, skinid, item ) ;
		}
		case 14407: // Рюкзак Flowers
		{
			SetAttachToSkin(playerid, 119, skinid, item ) ;
		}
		case 14406: // Рюкзак Kitty
		{
			SetAttachToSkin(playerid, 118, skinid, item ) ;
		}
		case 14405: // Рюкзак Mike
		{
			SetAttachToSkin(playerid, 117, skinid, item ) ;
		}
		case 14404: // Ранец (Louis Vuitton)
		{
			SetAttachToSkin(playerid, 116, skinid, item ) ;
		}
		case 14403: // Рюкзак Tiger
		{
			SetAttachToSkin(playerid, 115, skinid, item ) ;
		}
		case 14402: // Сумочка Gucci #2
		{
			SetAttachToSkin(playerid, 114, skinid, item ) ;
		}
		case 14401: // Сумочка Gucci
		{
			SetAttachToSkin(playerid, 113, skinid, item ) ;
		}
		case 14400: // Рюкзак (GreyAndBlack)
		{
			SetAttachToSkin(playerid, 112, skinid, item ) ;
		}
		case 14399: // Рюкзак (WhiteAndBlack)
		{
			SetAttachToSkin(playerid, 111, skinid, item ) ;
		}
		case 14398: // Рюкзак (Gold)
		{
			SetAttachToSkin(playerid, 110, skinid, item ) ;
		}
		case 14395, 14396, 14397: // Хиджабы
		{
			SetAttachToSkin(playerid, 109, skinid, item ) ;
		}
		case 18166: // Маска быка
		{
			SetAttachToSkin(playerid, 108, skinid, item ) ;
		}
		case 18165: // Маска хоккейная
		{
			SetAttachToSkin(playerid, 107, skinid, item ) ;
		}
		case 18164: // Маска неизвестно
		{
			SetAttachToSkin(playerid, 106, skinid, item ) ;
		}
		case 18163: // Маска тигра
		{
			SetAttachToSkin(playerid, 105, skinid, item ) ;
		}
		case 18162: // Маска Playboy
		{
			SetAttachToSkin(playerid, 104, skinid, item ) ;
		}
		case 18161: // Новогодний шарф
		{
			SetAttachToSkin(playerid, 103, skinid, item ) ;
		}
		case 18160: // Маска ёлки
		{
			SetAttachToSkin(playerid, 102, skinid, item ) ;
		}
		case 18159: // Маска собаки
		{
			SetAttachToSkin(playerid, 101, skinid, item ) ;
		}
		case 18158: // Маска Деда Мороза
		{
			SetAttachToSkin(playerid, 100, skinid, item ) ;
		}
		case 18157: // Шапка Санты
		{
			SetAttachToSkin(playerid, 99, skinid, item ) ;
		}
		case 18156: // Шапка ушанка
		{
			SetAttachToSkin(playerid, 98, skinid, item ) ;
		}
		case 10971..10982: // Маски
		{
			SetAttachToSkin(playerid, 97, skinid, item ) ;
		}
		case 14121..14126: // Рюкзаки (Матрешка)
		{
			SetAttachToSkin(playerid, 96, skinid, item ) ;
		}
		case 14110..14120: // Кепки (Матрешка)
		{
			SetAttachToSkin(playerid, 95, skinid, item ) ;
		}
		case 14105..14109: // Браслеты (Матрешка)
		{
			SetAttachToSkin(playerid, 94, skinid, item ) ;
		}
		case 14100..14104: // Очки (Матрешка)
		{
			SetAttachToSkin(playerid, 93, skinid, item ) ;
		}
		
		// Дефолтные аксессуары
		case 481: // BMX
		{
			SetAttachToSkin(playerid, 123, skinid, item ) ;
		}
	    case 19332, 19333, 19334, 19335, 19336, 19337, 19338: // Воздушные шары
		{
		    SetAttachToSkin(playerid, 74, skinid, item ) ;
		}
	    case 19472://Противогаз
		{
			SetAttachToSkin(playerid, 57, skinid, item ) ;
		}
		case 19142,19904://Жилеты
		{
			SetAttachToSkin(playerid, 80, skinid, item ) ;
		}
		case 1276://Амулет
		{
			SetAttachToSkin(playerid, 59, skinid, item ) ;
		}
		case 19079://Попугай
		{
			SetAttachToSkin(playerid, 23, skinid, item ) ;
		}
		case 19137://Петух
		{
			SetAttachToSkin(playerid, 62, skinid, item ) ;
		}
		case 18637://Щит
		{
			SetAttachToSkin(playerid, 55, skinid, item ) ;
		}
		case 355://AK-47
		{
			SetAttachToSkin(playerid, 23, skinid, item ) ;
		}
		case 19036, 19037, 19038: // Маски
		{
		    SetAttachToSkin(playerid, 41, skinid, item ) ;
		}
		case 18938, 18937, 19118: // Каски
		{
		    SetAttachToSkin(playerid, 44, skinid, item ) ;
		}
		case 19469: // Повязка на руку
		{
		    SetAttachToSkin(playerid, 15, skinid, item ) ;
		}
		case 19094: // Бургер
		{
		    SetAttachToSkin(playerid, 69, skinid, item ) ;
		}
		case 19314: // Рога
		{
		    SetAttachToSkin(playerid, 71, skinid, item ) ;
		}
		case 8492: // Крылья
		{
		    SetAttachToSkin(playerid, 75, skinid, item ) ;
		}
		case 2511: // Самолётик
	    {
	        SetAttachToSkin(playerid, 76, skinid, item ) ;
		}
		case 11712: // Крест
	    {
	        SetAttachToSkin(playerid, 77, skinid, item ) ;
		}
		case 19197: // Нимб
	    {
	        SetAttachToSkin(playerid, 78, skinid, item ) ;
		}
		case 11704: // Голова дьявола
	    {
	        SetAttachToSkin(playerid, 79, skinid, item ) ;
		}
		
		case 19042..19053: SetAttachToSkin(playerid, 15, skinid, item ) ; // Часы
		case 19421..19424://Наушники
		{
			SetAttachToSkin(playerid, 14, skinid, item ) ;
		}
		case 18911..18920: //банданы
		{
			SetAttachToSkin(playerid, 13, skinid, item ) ;
		}
		case 19011..19019,19024,19027,19028,19029,19022,19035,19031,19032,19033://Очки
		{
			SetAttachToSkin(playerid, 12, skinid, item ) ;
		}
		case 19069,19068,19067://Шапки
		{
			SetAttachToSkin(playerid, 1, skinid, item ) ;
		}
		case 19554: //Шапка баллас
		{
			SetAttachToSkin(playerid, 3, skinid, item ) ;
		}
		case 18953,18954: //Тёплые шапки
		{
			SetAttachToSkin(playerid, 2, skinid, item ) ;
		}
		case 18968,18967,18969://Панамки
		{
			SetAttachToSkin(playerid, 4, skinid, item ) ;
		}
		case 18955,18956,18957,18959://Кепки на зад
		{
			SetAttachToSkin(playerid, 5, skinid, item ) ;
		}
		case 18926,18927,18928,18929,18930,18931,18932,18933: //Кепки наперёд
		{
			SetAttachToSkin(playerid, 6, skinid, item ) ;
		}
		case 19104,19105,19106,19107,19108,19109://Каски
		{
			SetAttachToSkin(playerid, 9, skinid, item ) ;
		}
		case 19519://Парики 1
		{
			SetAttachToSkin(playerid, 10, skinid, item ) ;
		}
		case 19274://Парики 2
		{
			SetAttachToSkin(playerid, 11, skinid, item ) ;
		}
		case 18925,18922,18923,18924,18921: //Береты
		{
			SetAttachToSkin(playerid, 8, skinid, item ) ;
		}
		case 18947,18948,18949,18950,18951: //Шляпы
		{
			SetAttachToSkin(playerid, 7, skinid, item ) ;
		}
		//Рюкзаки
		case 3026:
		{
			SetAttachToSkin(playerid, 16, skinid, item ) ;
		}
		case 371:
		{
			SetAttachToSkin(playerid, 17, skinid, item ) ;
		}
		case 19559:
		{
			SetAttachToSkin(playerid, 18, skinid, item ) ;
		}
		//Вип
		//Шляпы 1
		case 18970, 18973, 18972, 18971:
		{
			SetAttachToSkin(playerid, 19, skinid, item ) ;
		}
		//Шляпы 2
		case 19487, 19352:
		{
			SetAttachToSkin(playerid, 20, skinid, item ) ;
		}
		//Банданы на голову
		case 18910, 18909, 18908, 18907, 18906:
		{
			SetAttachToSkin(playerid, 21, skinid, item ) ;
		}
		//Усы
		case 19351:
		{
			SetAttachToSkin(playerid, 22, skinid, item ) ;
		}
		//Усы
		case 19350:
		{
			SetAttachToSkin(playerid, 24, skinid, item ) ;
		}
		//Гитары
		case 19319, 19318, 19317:
		{
			SetAttachToSkin(playerid, 23, skinid, item ) ;
		}
		case 19064..19066://шапки новогоднии
		{
			SetAttachToSkin(playerid, 25, skinid, item ) ;
		}
		case 19085://повязка
		{
			SetAttachToSkin(playerid, 26, skinid, item ) ;
		}
		case 19054..19058://новогодний рюкзак
		{
			SetAttachToSkin(playerid, 27, skinid, item ) ;
		}
		case 881://Ёлка
		{
			SetAttachToSkin(playerid, 28, skinid, item ) ;
		}
		case 19624,11745: //Чемодан
		{
			SetAttachToSkin(playerid, 29, skinid, item ) ;
		}
	}
	return true ;
}

stock CheckAttackFreeSlotWeapon ( playerid, item )
{
	switch ( item )
	{
		case 3500, 3501, 3502:
		{
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				if ( GetUserAccessories ( playerid, ACS_MODEL, i ) != item ) continue ;

				return false ;
			}
		}
		case 3503, 3504, 3505, 3506:
		{
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				if ( GetUserAccessories ( playerid, ACS_MODEL, i ) != item ) continue ;

				return false ;
			}
		}
		case 3507, 3508, 3509:
		{
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				if ( GetUserAccessories ( playerid, ACS_MODEL, i ) != item ) continue ;

				return false ;
			}
		}
		case 3510, 3511:
		{
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				if ( GetUserAccessories ( playerid, ACS_MODEL, i ) != item ) continue ;

				return false ;
			}
		}
		case 3512, 3513, 3514, 3515:
		{
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				if ( GetUserAccessories ( playerid, ACS_MODEL, i ) != item ) continue ;

				return false ;
			}
		}
		case 3516, 3517, 3518, 3519:
		{
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				if ( GetUserAccessories ( playerid, ACS_MODEL, i ) != item ) continue ;

				return false ;
			}
		}
		case 3520, 3521, 3522, 3523:
		{
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				if ( GetUserAccessories ( playerid, ACS_MODEL, i ) != item ) continue ;

				return false ;
			}
		}
	}
	return true ;
}

stock CheckAttackFreeSlot ( playerid, item )
{
	switch ( item )
	{
		// Левая рука
		case 12100, 12101, 12102, 12103, 12104:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}

		// Спина
		case 12105, 12106, 12107, 12108, 12112, 12113, 12114,
		12135, 12136, 12138, 12140, 12152, 12153, 12154, 12155, 12160:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}

		// Голова
		case 12109, 12110, 12111, 12115, 12116, 12117, 12118, 12119, 12120, 12121, 12122, 12123,
		12124, 12125, 12126, 12127, 12128, 12129, 12130, 12131, 12132, 12133, 12134, 12137, 12142,
		12144, 12145, 12148, 12149, 12150, 12151, 12156, 12158, 12159, 12161:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}

		// update november 2022
		case 11755, 11756, 11757, 11758, 11759, 11760, 11761, 11765, 11767, 11768, 11769, 11770, 11771, 14050..14055,
			14056..14062, 14073, 14094, 14133, 14134, 14074..14078, 14079..14083, 14084..14088, 14089..14093, 14150..14154,
			14155..14159, 14160..14164, 14165..14169: // голова
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 11763, 11764, 11773..11779, 14063..14068, 14069..14072, 14135..14139, 14140..14144, 14145..14148: // Рюкзаки
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 11781, 11782, 11783: // Жилеты
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 11762, 11766, 11780: // плечо
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 8 ) ) return 0 ;
		}
		
		case 14423, 14424, 14425, 14426, 14427: // Очки (Матрешка)
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}
		case 14432, 14434, 14435, 14436, 14437: // Маски
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 14428, 14429, 14430, 14431, 14433, 14438, 14439: // Маски
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 14398, 14399, 14400, 14403, 14404, 14405, 14406, 14407: // Рюкзаки
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 14401, 14402: // Сумочки
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 4 ) ) return 0 ;
		}
		case 14395, 14396, 14397: // Хиджабы
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18156..18166:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 10971..10982: // Маски
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 14121..14126: // Рюкзаки (Матрешка)
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 14110..14120: // Кепки (Матрешка)
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 14105..14109: // Браслеты (Матрешка)
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}
		case 14100..14104: // Очки (Матрешка)
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}
		
		// Дефолтные аксессуары
		case 481: // BMX
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
	    case 19472://Противогаз
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 9 ) ) return 0 ;
		}
		case 19142,19904://Жилеты
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 1276://Амулет
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 19079://Попугай
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 19137://Петух
		{
   			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18637://Щит
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 355://AK-47
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 19036, 19037, 19038: // Маски
		{
		    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18938, 18937, 19118: // Каски
		{
		    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 19469: // Повязка на руку
		{
		    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}
		case 19094: // Бургер
		{
		    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 19314: // Рога
		{
		    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 8492: // Крылья
		{
		    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 2511: // Самолётик
	    {
	        if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 11712: // Крест
	    {
	        if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 19197: // Нимб
		{
	        if ( IsPlayerAttachedObjectSlotUsed ( playerid, 9 ) ) return 0 ;
		}
		case 11704: // Голова дьявола
		{
	        if ( IsPlayerAttachedObjectSlotUsed ( playerid, 9 ) ) return 0 ;
		}

		case 19042..19053: if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ; // Часы
		case 19421..19424://Наушники
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 9 ) ) return 0 ;
		}
		case 18911..18920: //банданы
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}
		case 19011..19019,19024,19027,19028,19029,19022,19035,19031,19032,19033://Очки
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 8 ) ) return 0 ;
		}
		case 19069,19068,19067://Шапки
		{
		    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 19554: //Шапка баллас
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18953,18954: //Тёплые шапки
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18968,18967,18969://Панамки
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18955,18956,18957,18959://Кепки на зад
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18926,18927,18928,18929,18930,18931,18932,18933: //Кепки наперёд
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 19104,19105,19106,19107,19108,19109://Каски
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 19519://Парики 1
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 19274://Парики 2
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18925,18922,18923,18924,18921: //Береты
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 18947,18948,18949,18950,18951: //Шляпы
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		//Рюкзаки
		case 3026:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 371:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 19559:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		//Вип
		//Шляпы 1
		case 18970, 18973, 18972, 18971:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		//Шляпы 2
		case 19487, 19352:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		//Банданы на голову
		case 18910, 18909, 18908, 18907, 18906:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		//Усы
		case 19351:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}
		//Усы
		case 19350:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 7 ) ) return 0 ;
		}
		//Гитары
		case 19319, 19318, 19317:
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 19064..19066://шапки новогоднии
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 5 ) ) return 0 ;
		}
		case 19085://повязка
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 8 ) ) return 0 ;
		}
		case 19054..19058://новогодний рюкзак
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 881://Ёлка
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 6 ) ) return 0 ;
		}
		case 19624,11745: //Чемодан
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 9 ) ) return 0 ;
		}
	}
	return 1 ;
}

stock SetAttachToSkin ( playerid, type, skinid, setobject )
{
	if(type == 1)
	{
		switch ( skinid )//Красные шапки
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.000000,1.000000,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.187000,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.187000,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.187000,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.033000,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.004999,0.000998, 0.000000,90.000000,95.899993, 1.000000,1.000000,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098997,0.000999,0.000998, 0.000000,90.000000,95.899993, 1.175000,1.000000,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.006999,0.000998, 0.000000,90.000000,95.899993, 1.092000,1.000000,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,-0.006000,0.000998, 0.000000,90.000000,95.899993, 1.137000,1.050999,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.021999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,-0.013999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.017000,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,-0.000999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,-0.000999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,-0.000999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.017000,0.001998, 0.000000,90.000000,95.899993, 0.987000,1.091999,0.866999 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.017000,0.001998, 0.000000,90.000000,95.899993, 1.122000,1.091999,0.866999 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.021000,0.001998, 0.000000,90.000000,95.899993, 1.181999,1.091999,0.866999 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130997,0.017000,-0.003001, 0.000000,90.000000,95.899993, 1.181999,1.091999,0.866999 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104997,0.006000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.006000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074997,0.006000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103997,0.027000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103997,0.009000,-0.003001, 0.000000,90.000000,95.899993, 1.071000,1.091999,0.866999 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129997,0.022000,-0.003001, 0.000000,90.000000,95.899993, 1.071000,1.091999,0.866999 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129997,0.022000,-0.003001, 0.000000,90.000000,95.899993, 1.125999,1.091999,0.866999 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,-0.002999,-0.003001, 0.000000,90.000000,95.899993, 1.125999,1.091999,0.866999 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.024000,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.035999,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,-0.014000,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,-0.014000,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,0.014999,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.005999,-0.002001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,0.007999,-0.002001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.002999,-0.002001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.012999,0.008999, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999 ) ;
			case 63: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.000999,0.004999, 0.000000,90.000000,95.899993, 1.104999,1.091999,0.866999 ) ;
			case 64: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.007999,0.004999, 0.000000,90.000000,95.899993, 1.104999,1.091999,0.866999 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.025999,0.004999, 0.000000,90.000000,95.899993, 1.104999,1.091999,0.866999 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.024999,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,-0.004000,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.019999,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.005999,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999 ) ;
			case 75: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.015000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.003000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.034000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.016000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.016000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000 ) ;
			case 85: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.016000,-0.010001, 0.000000,90.000000,95.400001, 1.151999,1.240999,1.000000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,0.016000,-0.004000, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000 ) ;
			case 88: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,0.027000,-0.004000, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000 ) ;
			case 89: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.007000,0.005999, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.007000,0.005999, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,-0.001999,0.005999, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,-0.003999,0.005999, 0.000000,90.000000,95.400001, 0.967999,1.048999,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.005000,0.005999, 0.000000,90.000000,95.400001, 0.967999,1.048999,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,-0.011999,0.005999, 0.000000,90.000000,95.400001, 0.967999,1.048999,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122997,0.032000,0.005999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.009000,0.005999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.009000,0.005999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.002000,-0.002000, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101997,0.002000,-0.002000, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.002000,0.002999, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114997,0.012000,0.003999, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.019000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.004000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.004000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.010000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.007000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.007000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129997,0.000000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.003999,0.000999, 0.000000,90.000000,95.400001, 1.009999,1.147000,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.003999,0.000999, 0.000000,90.000000,95.400001, 1.009999,1.147000,1.000000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.026000,-0.010001, 0.000000,90.000000,95.400001, 1.009999,1.147000,1.000000 ) ;
			case 129: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.016000,-0.004000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000 ) ;
			case 130: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,0.019000,-0.001000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.035998,0.005000,-0.001000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000 ) ;
			case 138: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.005000,-0.001000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000 ) ;
			case 144: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,-0.007999,-0.001000, 0.000000,90.000000,95.400001, 1.009999,1.087000,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.001999,-0.001000, 0.000000,90.000000,95.400001, 1.009999,1.087000,1.000000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.001999,-0.001000, 0.000000,90.000000,95.400001, 1.009999,1.087000,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,-0.004999,0.010999, 0.000000,90.000000,95.400001, 1.176999,1.087000,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.009000,0.000999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,-0.002999,0.005999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.012000,0.005999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.012000,0.005999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,-0.007999,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.011000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.008000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.004000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.182998,-0.009999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.000000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.003999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.026000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120998,0.014000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.004000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.004000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,-0.006999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.006000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.006000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,-0.001999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,-0.001999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,0.001000,0.002998, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.001000,-0.001001, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,0.004000,-0.009001, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.021999,0.001999, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.021999,0.001999, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,0.011000,-0.004000, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142997,0.015000,0.000999, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150997,0.015000,0.000999, 0.000000,90.000000,96.400009, 1.231999,1.000000,1.000000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,0.005000,0.000999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,-0.001999,0.001999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.076998,-0.001999,0.001999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,0.010000,0.001999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.010000,0.001999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.010000,0.001999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.010000,0.005999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.003000,0.005999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.003000,0.005999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,0.022000,-0.003000, 0.000000,90.000000,96.400009, 0.964999,1.000000,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.010000,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.079000,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.010000,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.079000,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.009999,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.079000,1.000000 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.004000,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.004000,-0.005000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.004000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.003000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.013000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,0.015000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.162998,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119997,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,-0.005999,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,0.007000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,0.007000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,0.007000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.007000,0.007999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.007000,0.007999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.003000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.003000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.003000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000 ) ;
		}
	}
	else if(type == 2)
	{
		switch (skinid)//У™плые шапки
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.016000,-0.002001, 0.000000,-0.799996,-8.600006, 1.000000,1.000000,1.050999 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.022000,0.008999, 2.000010,-5.999990,5.400008, 1.000000,1.042000,1.079000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,0.018000,-0.000001, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.079000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,0.018000,-0.000001, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.079000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,0.032000,-0.004001, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.079000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113997,0.017000,-0.004001, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.079000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106997,0.017000,-0.004001, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.079000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106997,0.017000,-0.004001, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.079000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106997,0.007000,-0.002001, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.079000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.032000,0.003998, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.146000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098997,0.008000,0.003998, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.146000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120997,0.020000,0.003998, 2.000010,2.000011,1.000008, 1.000000,1.042000,1.146000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,0.016000,0.003998, 2.000010,2.000011,-17.799989, 1.000000,1.042000,1.146000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.004000,0.000998, 2.000010,2.000011,-17.799989, 1.000000,1.042000,1.146000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,0.014000,-0.000001, 2.000010,2.000011,-17.799989, 1.000000,1.042000,1.146000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.023000,-0.000001, 2.000010,2.000011,-17.799989, 1.000000,1.042000,1.146000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.026000,-0.000001, 2.000010,2.000011,-17.799989, 1.000000,1.131000,1.206000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.026000,-0.000001, 2.000010,2.000011,-17.799989, 1.000000,1.131000,1.206000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.005000,-0.000001, 2.000010,2.000011,-17.799989, 1.000000,1.052000,1.206000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.063998,0.015000,-0.000001, 2.000010,2.000011,-17.799989, 1.000000,1.052000,1.206000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.027000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.909000,1.206000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.005000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.974000,1.206000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.040000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,1.070000,1.206000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.017000,-0.003000, 2.000010,2.000011,-17.799989, 1.000000,1.070000,1.206000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.004000,-0.003000, 2.000010,2.000011,-17.799989, 1.000000,1.070000,1.206000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,0.020000,-0.003000, 2.000010,2.000011,-17.799989, 1.000000,1.070000,1.206000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,-0.000999,0.000999, 2.000010,2.000011,-17.799989, 1.000000,1.070000,1.206000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,-0.000999,0.000999, 2.000010,2.000011,-17.799989, 1.000000,1.070000,1.206000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.025000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,1.070000,1.206000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,0.014000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.953000,0.969000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,0.006000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.953000,0.969000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.006000,-0.004000, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.025000,0.005999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.023000,0.005999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.023000,0.005999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.030000,-0.000000, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.024000,0.006999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.024000,0.006999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.024000,0.006999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.024000,0.006999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.024000,0.006999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.001000,0.006999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.001000,0.003999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114998,0.020000,0.003999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114998,0.010000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.029000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.009000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.009000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.009000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.009000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.009000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.009000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.018000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.013000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.013000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.005000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114998,0.020000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114998,0.020000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.020000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.000000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.000000,0.000999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.084000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.005000,-0.003000, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.013000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.021000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.001000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.014000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.025000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.000999,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.009999,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.024000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.017000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.011000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.011000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.018000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.018000,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,-0.003999,0.002999, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.017000,-0.001000, 2.000010,2.000011,-17.799989, 1.000000,0.967000,1.166000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.009000,-0.001000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.005000,-0.001000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.009000,-0.001000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.005000,-0.001000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,0.018000,-0.001000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,0.018000,-0.001000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,0.018000,-0.003000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.018000,-0.002000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.000000,-0.002000, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,0.005000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,0.011000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.003000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.001000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.001000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.007000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.007000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.008000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 199: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,0.008000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.008000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,1.043000,1.166000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.020000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114998,0.012000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114998,0.004000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.010000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.021000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 218: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.015000,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.012999,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,-0.017999,0.001999, 2.000010,2.000011,-17.799989, 1.000000,0.970000,1.166000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,0.014000,0.001999, 2.000010,2.000011,-26.199983, 1.000000,0.970000,1.166000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.003000,0.001999, 2.000010,2.000011,-10.499980, 1.000000,0.970000,1.166000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.029000,0.001999, 2.000010,2.000011,-10.499980, 1.000000,0.970000,1.166000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.023000,0.001999, 2.000010,2.000011,-10.499980, 1.000000,1.132000,1.166000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,0.011000,0.001999, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.002999,0.001999, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.073998,0.010000,0.001999, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,0.010000,0.001999, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.015000,0.001999, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 243: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.091998,0.023000,0.001998, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.023000,-0.004001, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.005000,0.003998, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.019000,0.003998, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.010000,0.003998, 2.000010,2.000011,-10.499980, 1.000000,1.013000,1.166000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.027000,-0.002001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.015000,-0.002001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.013000,-0.002001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.007999,0.002998, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.000000 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.007999,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,0.019000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.000000,1.085999 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.020000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.075999,1.085999 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.020000,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.075999,1.085999 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.003999,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.075999,1.085999 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,0.003999,-0.001001, 0.000000,0.899997,-5.699998, 1.000000,1.075999,1.131999 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.021000,-0.003001, 0.000000,0.899997,-5.699998, 1.000000,1.075999,1.131999 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.030000,-0.003001, 0.000000,0.899997,-23.200000, 1.000000,1.075999,1.131999 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.013000,-0.003001, 0.000000,0.899997,-7.599999, 1.000000,0.885999,1.131999 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.013000,-0.003001, 0.000000,0.899997,-7.599999, 1.000000,0.885999,1.131999 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.021000,-0.003001, 0.000000,0.899997,-7.599999, 1.000000,0.909999,1.131999 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.021000,-0.000001, 0.000000,0.899997,-7.599999, 1.000000,0.909999,1.034999 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.021000,-0.000001, 0.000000,0.899997,-7.599999, 1.000000,0.909999,1.034999 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.021000,-0.000001, 0.000000,0.899997,-7.599999, 1.000000,0.909999,1.034999 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.021000,-0.000001, 0.000000,0.899997,-7.599999, 1.000000,0.909999,1.034999 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.021000,-0.000001, 0.000000,0.899997,-7.599999, 1.000000,0.909999,1.034999 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.021000,-0.000001, 0.000000,0.899997,-7.599999, 1.000000,0.909999,1.034999 ) ;
		}
	}
	else if(type == 3)
	{
		switch (skinid)//°апки баллас
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.009999,0.001998, 0.400000,-3.699999,12.699994, 1.114999,1.000000,1.238999 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.013000,0.004998, 0.400000,-3.699999,12.699994, 1.114999,1.245000,1.238999 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.181997,0.000999,0.004998, 0.400000,-3.699999,12.699994, 1.114999,1.245000,1.238999 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.181997,0.000999,0.004998, 0.400000,-3.699999,12.699994, 1.114999,1.245000,1.238999 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154997,0.025000,0.004998, 0.400000,-3.699999,12.699994, 1.114999,1.245000,1.238999 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,0.007999,0.004998, 0.400000,-3.699999,12.699994, 1.114999,1.245000,1.238999 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,-0.000000,0.004998, 0.400000,-3.699999,12.699994, 1.114999,1.245000,1.238999 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,-0.006000,0.004998, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.238999 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,-0.025000,0.004998, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.238999 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,0.011999,0.004999, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.297000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114997,-0.025000,0.004999, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.297000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153997,0.005000,0.004999, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.297000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114997,-0.003999,0.004999, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.297000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165997,-0.014999,0.004999, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.297000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150997,-0.003999,0.000998, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.297000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135997,0.010000,0.006999, 0.400000,-3.699999,-0.400006, 1.114999,1.245000,1.297000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150997,0.004000,0.006999, 0.400000,-3.699999,-0.400006, 1.114999,1.344000,1.297000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,0.011000,-0.004001, 0.400000,-3.699999,-0.400006, 1.114999,1.344000,1.297000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,0.005000,-0.004001, 0.400000,-3.699999,-0.400006, 1.114999,1.344000,1.297000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,-0.018999,0.007999, 0.400000,-3.699999,-0.400006, 1.114999,1.344000,1.297000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108997,-0.009000,0.007999, 0.400000,-3.699999,-0.400006, 1.114999,1.132000,1.297000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108997,0.011999,0.007999, 0.400000,-3.699999,-0.400006, 1.114999,1.132000,1.297000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120997,-0.008000,0.007999, 0.400000,-3.699999,-0.400006, 1.114999,1.132000,1.297000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152997,0.006999,0.007999, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152997,0.000999,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152997,-0.014000,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109997,0.007999,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125997,-0.010000,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125997,-0.020000,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157997,0.013999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.000999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.214000,1.367000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164997,-0.002000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.311000,1.367000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,-0.002000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,0.004999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,0.003999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,0.017999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,-0.010000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,0.013999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,0.007999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,-0.016000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.367000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.195997,0.004999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.145000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.195997,-0.006000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.145000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.195997,-0.006000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.145000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,-0.012000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.164000,1.145000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,-0.001000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.356000,1.264000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,-0.015000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.356000,1.264000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,-0.023000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.137000,1.264000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,0.001999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.137000,1.264000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,-0.005000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.137000,1.264000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,0.012999,-0.002001, 0.400000,-3.699999,-0.400006, 1.114999,1.247000,1.264000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.008000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.247000,1.264000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.008000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.247000,1.264000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163997,-0.008000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.247000,1.264000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.003000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.247000,1.264000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.003000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.356000,1.314000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.003000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.356000,1.314000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.003000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.108000,1.314000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133997,-0.003000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,0.987000,1.314000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166997,-0.005000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.314000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166997,-0.005000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.314000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166997,-0.005000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.314000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121997,0.010999,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.314000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121997,0.010999,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.314000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.007999,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.314000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.003999,0.004999, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.314000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.003999,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.374000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,-0.000000,0.003998, 0.400000,-3.699999,-0.400006, 1.114999,1.204000,1.374000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143997,-0.002000,-0.000001, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143997,-0.002000,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122997,0.008999,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131997,0.000999,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131997,0.000999,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142997,0.007999,0.001998, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,-0.011000,0.005998, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,-0.010000,0.005998, 0.400000,-3.699999,-0.400006, 1.114999,1.278000,1.374000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,-0.019000,0.005998, 0.400000,-3.699999,-0.400006, 1.114999,1.371001,1.374000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,-0.001000,0.005998, 0.400000,-3.699999,-0.400006, 1.114999,1.207000,1.374000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.170997,-0.023000,0.005998, 0.400000,-3.699999,-0.400006, 1.114999,1.207000,1.374000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.009999,0.005998, 0.400000,-3.699999,-0.400006, 1.114999,1.207000,1.374000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.000999,0.005998, 0.400000,-3.699999,-0.400006, 1.114999,1.018000,1.294000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.003999,0.005998, 0.400000,-3.699999,-0.400006, 1.188999,1.114001,1.294000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.008999,0.005998, 0.400000,-3.699999,-0.400006, 1.188999,1.114001,1.294000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.005999,0.005998, 0.400000,-3.699999,-0.400006, 1.188999,1.114001,1.294000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.003999,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.114001,1.352999 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.003999,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.114001,1.352999 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,-0.014000,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.114001,1.352999 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.000999,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.114001,1.352999 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,-0.005000,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.009000,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.009000,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.004000,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.010000,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121997,0.006999,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121997,0.001999,0.002998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121997,0.010999,-0.002001, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154997,-0.006000,0.000998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139997,-0.006000,0.004998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,-0.001000,0.004998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,-0.001000,0.004998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,-0.001000,0.004998, 0.400000,-3.699999,-0.400006, 1.188999,1.230001,1.352999 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158997,-0.007000,0.002998, 0.400000,-3.699999,-0.400006, 1.268999,1.383001,1.428999 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158997,-0.012000,0.002998, 0.400000,-3.699999,-0.400006, 1.268999,1.383001,1.428999 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158997,-0.012000,0.002998, 0.400000,-3.699999,-0.400006, 1.268999,1.383001,1.428999 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158997,-0.012000,0.002998, 0.400000,-3.699999,-0.400006, 1.268999,1.383001,1.428999 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140997,-0.012000,0.003998, 0.400000,-3.699999,-0.400006, 1.268999,1.383001,1.428999 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140997,0.019999,0.003998, 0.400000,-3.699999,-0.400006, 1.268999,1.071001,1.250999 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,-0.002000,0.003998, 0.400000,-3.699999,-0.400006, 1.268999,1.071001,1.250999 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.003999,0.003998, 0.400000,-3.699999,-0.400006, 1.268999,1.071001,1.250999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.003999,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.177001,1.327999 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142997,-0.003000,0.003998, 0.400000,-3.699999,-0.400006, 1.268999,1.177001,1.327999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161997,-0.015000,0.006998, 0.400000,-3.699999,-0.400006, 1.268999,1.257001,1.429999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.015000,0.006998, 0.400000,-3.699999,-0.400006, 1.268999,1.257001,1.429999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153997,0.012999,0.006998, 0.400000,-3.699999,-0.400006, 1.268999,1.386001,1.429999 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,-0.020000,0.006998, 0.400000,-3.699999,-0.400006, 1.268999,1.386001,1.429999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,0.018999,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.128001,1.429999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,0.004999,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.288001,1.429999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,-0.005000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.091001,1.429999 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,-0.015000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.091001,1.429999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096997,-0.007000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.091001,1.283999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120997,-0.002000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.091001,1.283999 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.001000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.264001,1.283999 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.001000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.264001,1.283999 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.182997,-0.004000,0.002998, 0.400000,-3.699999,-0.400006, 1.268999,1.323001,1.283999 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146997,0.004999,0.002998, 0.400000,-3.699999,-0.400006, 1.268999,1.323001,1.283999 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146997,-0.008999,0.002998, 0.400000,-3.699999,-0.400006, 1.268999,1.323001,1.283999 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146997,-0.008999,0.007998, 0.400000,-3.699999,-0.400006, 1.268999,1.323001,1.283999 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146997,-0.004999,0.007998, 0.400000,-3.699999,-0.400006, 1.268999,1.323001,1.411999 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146997,-0.008999,0.007998, 0.400000,-3.699999,-0.400006, 1.268999,1.323001,1.411999 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.007000,0.003998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.007000,0.003998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,0.000000,-0.004001, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.008999,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.008999,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149997,-0.001999,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,-0.004999,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.002000,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.002000,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,0.002000,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,0.001000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.146001,1.411999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,0.006000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.057001,1.208999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,0.011000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.057001,1.208999 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,0.006000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.057001,1.208999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159997,0.010000,0.004998, 0.400000,-3.699999,-0.400006, 1.268999,1.278001,1.319999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128997,0.001000,-0.001001, 0.400000,-3.699999,-0.400006, 1.268999,1.014001,1.137000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128997,0.001000,-0.001001, 0.400000,-3.699999,-0.400006, 1.268999,1.014001,1.216000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156997,0.008000,0.000998, 0.400000,-3.699999,-0.400006, 1.268999,1.231001,1.216000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135997,0.001000,0.005998, 0.400000,-3.699999,-0.400006, 1.268999,1.231001,1.295000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135997,-0.006999,0.005998, 0.400000,-3.699999,-0.400006, 1.268999,1.363001,1.295000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156997,-0.000999,0.005998, 0.400000,-3.699999,-0.400006, 1.268999,1.363001,1.295000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.178997,0.011000,0.005998, 0.400000,-3.699999,-0.400006, 1.268999,1.363001,1.295000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135997,0.007000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.101001,1.295000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135997,0.007000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.101001,1.295000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135997,0.007000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.179001,1.295000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.012000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.179001,1.295000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.006000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.179001,1.295000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.006000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.179001,1.295000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.001000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.179001,1.295000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.000000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.179001,1.295000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.000000,-0.000001, 0.400000,-3.699999,-0.400006, 1.134999,1.179001,1.295000 ) ;
		}
	}
	else if(type == 4)
	{
		switch (skinid)//Њанамки
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,-0.005001, 0.000000,90.000000,93.500007, 1.000000,1.000000,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.007999,0.001998, 0.000000,90.000000,93.500007, 1.000000,1.000000,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.015000,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,0.004999,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,0.018000,-0.000001, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.006999,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.006999,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.012000,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,-0.000000,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.027000,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,-0.013000,0.001998, 0.000000,90.000000,93.500007, 1.043999,1.123999,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,0.002998, 0.000000,90.000000,93.699989, 1.000000,1.000000,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.013000,0.000998, 0.000000,90.000000,93.699989, 1.000000,1.000000,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.013000,0.000998, 0.000000,90.000000,93.699989, 1.000000,1.000000,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.009999,0.000998, 0.000000,90.000000,93.699989, 1.000000,1.000000,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.014000,0.000998, 0.000000,90.000000,93.699989, 1.000000,1.000000,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.014000,0.000998, 0.000000,90.000000,93.699989, 1.000000,1.000000,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.014000,-0.002001, 0.000000,90.000000,93.699989, 1.000000,1.074000,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,-0.003000,-0.002001, 0.000000,90.000000,93.699989, 1.000000,1.074000,1.000000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,0.017999,-0.002001, 0.000000,90.000000,93.699989, 1.000000,1.074000,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.029000,-0.002001, 0.000000,90.000000,93.699989, 1.000000,1.074000,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,0.008999,-0.002001, 0.000000,90.000000,93.699989, 1.000000,1.074000,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.037999,-0.001001, 0.000000,90.000000,93.699989, 1.078999,1.074000,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.023000,-0.001001, 0.000000,90.000000,93.699989, 1.078999,1.074000,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.004999,-0.005000, 0.000000,90.000000,93.699989, 1.078999,1.138000,1.000000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.020999,-0.005000, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.043999,-0.005000, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.004999,-0.005000, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.004999,-0.005000, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.031999,-0.004000, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.017999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.024999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.024999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.026999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.019999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.019999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.032999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.014999,0.000999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.032999,0.008999, 0.199999,91.999984,97.199958, 1.078999,1.138000,1.000000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.032999,0.001999, 0.199999,91.999984,90.599967, 0.977999,0.991000,1.000000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.032999,0.001999, 0.199999,91.999984,90.599967, 0.977999,0.991000,1.000000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.002999,0.001999, 0.199999,91.999984,90.599967, 0.977999,0.991000,1.000000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.006999,0.001999, 0.199999,91.999984,90.599967, 0.977999,0.991000,1.000000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.006999,0.006999, 0.199999,91.999984,90.599967, 0.977999,0.991000,1.000000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.182998,0.025999,0.003999, 0.199999,91.999984,90.599967, 0.977999,0.991000,1.000000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,0.020999,0.003999, 0.199999,91.999984,90.599967, 1.071999,0.991000,1.000000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,0.020999,0.003999, 0.199999,91.999984,90.599967, 1.071999,0.991000,1.000000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.011999,0.003999, 0.199999,91.999984,90.599967, 1.071999,0.991000,1.000000 ) ;
			case 88: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.032999,0.003999, 0.199999,91.999984,90.599967, 1.071999,0.991000,1.000000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.010999,0.003999, 0.199999,91.999984,90.599967, 1.071999,0.991000,1.000000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.005999,0.003999, 0.199999,91.999984,90.599967, 1.071999,0.991000,1.000000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.022999,0.001999, 0.199999,91.999984,90.599967, 1.071999,0.991000,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102998,0.001999,0.001999, 0.199999,91.999984,90.599967, 0.934999,0.991000,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.015999,-0.000000, 0.199999,91.999984,90.599967, 0.986999,1.020000,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.010999,-0.000000, 0.199999,91.999984,90.599967, 0.986999,1.020000,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.035999,-0.003000, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.015999,0.000999, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.015999,0.000999, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.015999,-0.005000, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.016999,-0.006001, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.016999,-0.001000, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.016999,-0.005001, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.016999,-0.005001, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.017999,0.000999, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.014999,0.000999, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.014999,0.000999, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,0.014999,-0.004000, 0.199999,91.999984,90.599967, 1.025999,1.020000,1.000000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,0.014999,-0.004000, 0.199999,91.999984,90.599967, 1.025999,1.041000,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.020999,-0.004000, 0.199999,91.999984,90.599967, 1.025999,1.041000,1.000000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.020999,-0.004000, 0.199999,91.999984,90.599967, 1.025999,1.041000,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.020999,-0.002000, 0.199999,91.999984,90.599967, 1.025999,1.041000,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.006999,0.003999, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.006999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.006999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.006999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.011999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.012999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.012999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.012999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,0.033999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 129: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.089998,0.030999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 130: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,0.030999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 131: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,0.030999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 146: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.014999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.002999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.002999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,0.002999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.002999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.171998,-0.002000,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,-0.001000,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.017999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.014999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.007999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.007999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.174998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.020999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.017999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.009999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.002999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.011999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.014999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 196: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 199: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.016999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.016999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.016999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,0.016999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.016999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.008999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.010999,-0.000000, 0.199999,91.999984,90.599967, 1.025999,1.094000,1.000000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.021999,-0.000000, 0.199999,91.999984,90.599967, 0.855999,1.005000,1.000000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.018999,-0.001001, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.001999,-0.001001, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 216: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.001999,-0.001001, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.015999,-0.001001, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 218: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.015999,-0.001001, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.008999,-0.001001, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.001999,-0.001001, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.007000,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.179998,0.021999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 224: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.004000,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 225: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.002000,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.009000,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.022999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,0.012999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,0.000999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102998,0.015999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.007999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.007999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.080998,0.007999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,0.007999,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 237: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.002000,0.000999, 0.199999,91.999984,90.599967, 0.947999,1.044000,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.017999,0.000999, 0.199999,91.999984,90.599967, 1.002999,1.090000,1.000000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,0.001998, 0.000000,90.000000,82.699989, 1.000000,1.057000,1.000000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,0.027000,-0.004001, 0.000000,90.000000,82.699989, 1.153000,1.136999,1.000000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.027000,-0.004001, 0.000000,90.000000,82.699989, 1.153000,1.136999,1.000000 ) ;
			case 251: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.027000,-0.004001, 0.000000,90.000000,82.699989, 1.153000,1.136999,1.000000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.020999,-0.004001, 0.000000,90.000000,82.699989, 1.153000,1.136999,1.000000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.020999,-0.004001, 0.000000,90.000000,82.699989, 1.153000,1.136999,1.000000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.020999,-0.004001, 0.000000,90.000000,82.699989, 1.153000,1.136999,1.000000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,0.030000,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 263: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.004999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.008999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.005999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.005999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.016999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.007999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.014999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.021999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.021999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.021999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.021999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.021999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.021999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.011999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,0.013999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.013999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167998,0.016999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.016999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.003000,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.160998,0.009999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.009999,0.001998, 0.000000,90.000000,82.699989, 0.936000,1.136999,1.000000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.172998,0.026999,0.001998, 0.000000,90.000000,82.699989, 1.037000,1.136999,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.026999,0.001998, 0.000000,90.000000,82.699989, 1.037000,1.136999,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.026999,0.001998, 0.000000,90.000000,82.699989, 1.037000,1.136999,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.016000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.016000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.016000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.007999,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.007999,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.007999,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.007999,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.015000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.015000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
		}
	}
	else if(type == 5)//†епки назад
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105997,0.034000,0.000998, 6.799999,90.000000,97.500000, 0.925999,1.092999,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,0.034000,-0.005001, 8.500000,89.899986,76.199981, 1.024999,1.115999,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139997,0.034000,0.006998, 8.500000,89.899986,99.799995, 1.090999,1.115999,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139997,0.034000,0.006998, 8.500000,89.899986,99.799995, 1.090999,1.115999,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129997,0.045000,-0.001001, 8.500000,89.899986,81.099990, 1.016000,1.055999,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116997,0.016999,-0.001001, 8.500000,89.899986,81.099990, 1.016000,1.055999,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093997,0.016999,-0.001001, 8.500000,89.899986,81.099990, 1.016000,1.055999,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104997,0.028999,-0.001001, 8.500000,89.899986,81.099990, 1.016000,1.055999,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094997,0.015999,-0.004001, 8.500000,89.899986,81.099990, 1.037000,1.123999,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120997,0.037000,-0.004001, 8.500000,89.899986,81.099990, 1.037000,1.123999,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106997,-0.001999,-0.005001, 8.500000,89.899986,81.099990, 1.037000,1.123999,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120997,0.031000,-0.002001, 8.500000,89.899986,81.099990, 1.037000,1.123999,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.085997,0.019000,0.000998, 8.500000,89.899986,81.099990, 0.947000,1.123999,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139997,0.014000,0.000998, 8.500000,89.899986,81.099990, 0.947000,1.123999,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.027000,-0.004001, 8.500000,89.899986,81.099990, 0.947000,1.123999,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.027000,0.004998, 8.500000,89.899986,81.099990, 0.947000,1.123999,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120998,0.029000,-0.002001, 8.500000,89.899986,81.099990, 1.047000,1.030999,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120998,0.029000,-0.007001, 8.500000,89.899986,81.099990, 1.047000,1.088999,1.000000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.082997,0.023000,-0.004000, 8.500000,89.899986,81.099990, 1.047000,1.088999,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101997,0.023000,-0.003001, 8.500000,89.899986,81.099990, 1.047000,1.156999,1.000000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.058998,0.026000,-0.009001, 8.500000,89.899986,81.099990, 0.913000,0.994999,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083997,0.036000,0.002998, 8.500000,89.899986,81.099990, 0.913000,0.994999,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,0.027000,-0.003001, 8.500000,89.899986,81.099990, 0.988000,1.017999,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.045999,-0.003001, 8.500000,89.899986,81.099990, 1.016000,1.113999,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.035000,-0.006001, 8.500000,89.899986,81.099990, 1.016000,1.113999,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.018000,-0.009001, 8.500000,89.899986,81.099990, 1.091000,1.150999,1.000000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097997,0.046000,-0.009001, 8.500000,89.899986,81.099990, 1.091000,1.150999,1.000000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097997,0.056999,-0.006001, 8.500000,89.899986,81.099990, 1.002000,1.049999,1.000000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109997,0.010999,-0.006001, 8.500000,89.899986,81.099990, 1.002000,1.049999,1.000000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109997,0.010999,-0.003001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,0.037999,-0.007001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.090997,0.017999,-0.007001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.026999,-0.004001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.026999,-0.005001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,0.036999,0.000998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.037999,0.000998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.033999,0.000998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.036999,0.000998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,0.025999,-0.006001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,0.040999,0.006998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.040999,-0.002001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.018999,-0.002001, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.035999,0.001998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.018999,0.001998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.018999,0.001998, 8.500000,89.899986,81.099990, 1.002000,1.081999,1.000000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,0.013999,-0.003001, 8.500000,89.899986,81.099990, 1.002000,1.011999,1.000000 ) ;
			case 88: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,0.049999,0.001998, 8.500000,89.899986,81.099990, 1.002000,1.011999,1.000000 ) ;
			case 89: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.007999,-0.001001, 8.500000,89.899986,81.099990, 1.002000,1.065999,1.000000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.027999,0.000998, 8.500000,89.899986,81.099990, 1.002000,1.123999,1.000000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.022999,0.000998, 8.500000,89.899986,81.099990, 1.002000,1.123999,1.000000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.022999,0.001998, 8.500000,89.899986,81.099990, 1.002000,1.123999,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093998,0.009999,0.001998, 8.500000,89.899986,81.099990, 1.002000,1.123999,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.031999,0.001998, 8.500000,89.899986,81.099990, 1.002000,1.123999,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092998,0.028999,0.001998, 8.500000,89.899986,81.099990, 1.042000,1.123999,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.044999,-0.005001, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.033999,-0.005001, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.028999,0.004999, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.019999,-0.006000, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.023999,-0.006000, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.037999,-0.004000, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.031999,-0.006000, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120998,0.030999,-0.002000, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.029999,-0.002000, 8.500000,89.899986,81.099990, 1.042000,1.016999,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.029999,-0.005000, 8.500000,89.899986,81.099990, 1.042000,1.059999,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.036999,-0.003000, 8.500000,89.899986,81.099990, 0.935000,0.948999,1.000000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.036999,-0.003000, 8.500000,89.899986,81.099990, 0.935000,0.948999,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.032999,-0.005000, 8.500000,89.899986,81.099990, 0.935000,1.012999,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.017999,-0.005000, 8.500000,89.899986,81.099990, 0.980000,1.012999,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.016000,0.004999, 0.000000,90.000000,115.000000, 1.000000,1.000000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.024000,-0.005001, 0.000000,90.000000,115.000000, 1.057999,1.191999,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.030000,-0.001000, 0.000000,90.000000,93.100013, 1.057999,1.102999,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.034000,-0.001000, 0.000000,90.000000,93.100013, 0.913999,1.102999,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.013000,-0.001000, 0.000000,90.000000,93.100013, 0.970999,1.102999,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.027000,0.000999, 0.000000,90.000000,93.100013, 1.066999,1.102999,1.000000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.046000,-0.008000, 0.000000,90.000000,93.100013, 1.099999,1.102999,1.000000 ) ;
			case 129: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,0.028000,0.000999, 0.000000,90.000000,93.100013, 0.797999,0.900999,1.000000 ) ;
			case 130: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.078998,0.028000,-0.004000, 0.000000,90.000000,93.100013, 0.797999,0.900999,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.006000,-0.000000, 0.000000,90.000000,93.100013, 0.850999,0.943999,1.000000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.000000,-0.000000, 0.000000,90.000000,93.100013, 0.850999,0.943999,1.000000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.013000,-0.000000, 0.000000,90.000000,93.100013, 0.913999,0.943999,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.002000,-0.000000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 152: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.002000,-0.000000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103997,0.006000,-0.000000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166997,0.001000,-0.000000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116997,0.021000,0.002999, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100997,0.027000,0.002999, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120997,0.031000,0.002999, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116997,0.031000,-0.003000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.022000,-0.003000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.032000,-0.004000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106997,0.032000,-0.004000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,-0.002999,-0.005000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139997,0.025000,-0.005000, 0.000000,90.000000,93.100013, 0.924999,0.998999,1.024999 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139997,0.016000,-0.002000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,0.016000,-0.000000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149997,0.016000,-0.004000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154997,0.021999,-0.004000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,0.021999,-0.005000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,0.013999,-0.009000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.025999,-0.002000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.025999,-0.002000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.025999,-0.005000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.025999,-0.001000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.016999,-0.001000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104997,0.016999,-0.001000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104997,0.024000,-0.001000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,0.018999,-0.000000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155997,0.012999,-0.005000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155997,0.018999,-0.003000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142997,0.023000,-0.003000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142997,0.023000,-0.003000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.021999,-0.003000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.044999,-0.003000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083997,0.033999,-0.003000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.043999,-0.003000, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084997,0.027999,0.002999, 0.000000,90.000000,93.100013, 1.000999,0.998999,1.024999 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.027999,-0.001000, 0.000000,90.000000,93.100013, 1.000999,1.021999,1.024999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.027999,-0.001000, 0.000000,90.000000,93.100013, 1.000999,1.021999,1.024999 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.019999,-0.001000, 0.000000,90.000000,93.100013, 1.000999,1.021999,1.024999 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.031999,-0.001000, 0.000000,90.000000,93.100013, 1.000999,1.021999,1.024999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,0.015999,-0.004000, 0.000000,90.000000,93.100013, 1.000999,1.121999,1.024999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,0.004999,0.000999, 0.000000,90.000000,93.100013, 1.000999,1.121999,1.024999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,0.034000,-0.004000, 0.000000,90.000000,93.100013, 1.000999,1.121999,1.024999 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.014000,-0.004000, 0.000000,90.000000,93.100013, 1.000999,1.121999,1.024999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129997,0.048000,-0.004000, 0.000000,90.000000,93.100013, 1.000999,1.121999,1.024999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128997,0.034000,-0.000000, 0.000000,90.000000,93.100013, 1.076999,1.121999,1.024999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094997,0.019000,-0.000000, 0.000000,90.000000,93.100013, 0.934999,1.003999,1.024999 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.099997,0.005000,-0.000000, 0.000000,90.000000,93.100013, 0.934999,1.003999,1.024999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.073998,0.020000,-0.001001, 0.000000,90.000000,101.900001, 1.000000,1.000000,1.000000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084998,0.032999,0.000998, 0.000000,90.000000,101.900001, 1.000000,1.000000,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.031999,-0.000001, 0.000000,90.000000,101.900001, 1.059000,1.115999,1.000000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.020999,-0.001001, 0.000000,90.000000,101.900001, 1.067000,1.068000,1.047000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,0.027999,-0.001001, 0.000000,90.000000,101.900001, 1.067000,1.068000,1.047000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122997,0.027999,-0.004001, 0.000000,90.000000,101.900001, 1.067000,1.068000,1.047000 ) ;
			case 251: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.027999,-0.001001, 0.000000,90.000000,101.900001, 1.067000,1.068000,1.047000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116997,0.026999,0.007998, 0.000000,90.000000,101.900001, 1.067000,1.068000,1.047000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116997,0.031999,0.002998, 0.000000,90.000000,101.900001, 1.067000,1.123000,1.047000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112997,0.025999,0.003998, 0.000000,90.000000,101.900001, 1.067000,1.123000,1.047000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.041999,-0.004001, 0.000000,90.000000,101.900001, 0.963000,0.953000,1.047000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.020999,-0.004001, 0.000000,90.000000,101.900001, 0.963000,0.953000,1.047000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.020999,-0.002001, 0.000000,90.000000,101.900001, 0.963000,0.996000,1.047000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110997,0.020999,0.000998, 0.000000,90.000000,101.900001, 0.963000,0.996000,1.047000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.020999,0.000998, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096997,0.025999,0.000998, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.026999,0.003998, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.026999,0.003998, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,0.024999,0.001998, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.029999,0.001998, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.029999,-0.003001, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.029999,-0.000001, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,0.034999,-0.000001, 0.000000,90.000000,101.900001, 1.011000,0.996000,1.047000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119997,0.024999,0.000998, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.032999,-0.001001, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.090997,0.028999,-0.003001, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.028999,-0.000001, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126997,0.023999,0.000998, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.005999,0.000998, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,0.015999,0.000998, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.035999,0.000998, 0.000000,90.000000,101.900001, 1.011000,1.086000,1.047000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.022999,0.000998, 0.000000,90.000000,101.900001, 0.877000,1.012000,1.047000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.022999,0.000998, 0.000000,90.000000,101.900001, 0.877000,1.012000,1.047000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.022999,0.000998, 0.000000,90.000000,101.900001, 0.877000,1.012000,1.047000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.029999,-0.002001, 0.000000,90.000000,101.900001, 0.908000,1.012000,1.047000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.029999,-0.002001, 0.000000,90.000000,101.900001, 0.908000,1.012000,1.047000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.029999,-0.000001, 0.000000,90.000000,101.900001, 0.908000,1.012000,1.047000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.024999,-0.002001, 0.000000,90.000000,101.900001, 0.908000,1.012000,1.047000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.027999,-0.002001, 0.000000,90.000000,101.900001, 0.908000,1.012000,1.047000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.015000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
		}
	}
	else if(type == 6)//†епки впер™д
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,-0.014001, -175.400024,173.999984,-178.299957, 1.000000,1.000000,1.072000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.016000,-0.014001, -175.400024,173.999984,-178.299957, 1.000000,1.167999,1.139000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.009999,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.167999,1.139000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.009999,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.167999,1.139000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.020000,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.099000,1.064999 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.002000,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.099000,1.064999 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.002000,-0.015001, -175.400024,173.999984,-178.299957, 1.000000,1.099000,1.064999 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.002000,-0.019001, -175.400024,173.999984,-178.299957, 1.000000,1.163000,1.153999 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.022000,-0.007000, -175.400024,173.999984,-178.299957, 1.000000,1.163000,1.153999 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,-0.004999,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.163000,1.153999 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.014000,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.163000,1.153999 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.004999,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.163000,1.153999 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.004999,-0.011001, -175.400024,173.999984,-178.299957, 1.000000,1.163000,1.153999 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.012000,-0.016001, -175.400024,173.999984,-178.299957, 1.000000,1.163000,1.153999 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.012000,-0.010001, -175.400024,173.999984,-178.299957, 1.000000,0.968000,1.044999 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.012000,-0.010001, -175.400024,173.999984,-178.299957, 1.000000,0.968000,1.044999 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.012999,-0.010001, -175.400024,173.999984,-178.299957, 1.000000,1.120000,1.075000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.000999,-0.018001, -175.400024,173.999984,164.000030, 1.000000,1.120000,1.218999 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.011000,-0.018001, -175.400024,173.999984,164.000030, 1.000000,1.120000,1.218999 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.024000,-0.018001, -175.400024,173.999984,164.000030, 1.000000,1.120000,1.218999 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093998,-0.004000,-0.009000, -175.400024,173.999984,164.000030, 0.954999,0.989000,1.042999 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,0.016999,-0.010001, -175.400024,173.999984,164.000030, 0.954999,0.989000,1.042999 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113998,-0.010000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.042999 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156997,-0.006000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.042999 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156997,-0.006000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.042999 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156997,-0.031000,-0.022001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.146000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,0.003999,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.146000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.014999,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.146000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,-0.033000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.146000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,-0.033000,-0.018001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.146000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.177997,0.000999,-0.018001, -175.400024,173.999984,164.000030, 0.954999,1.049000,1.146000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,-0.013000,-0.018001, -175.400024,173.999984,164.000030, 0.954999,0.982000,1.019999 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167997,-0.013000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.126000,1.019999 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140997,-0.001000,-0.015001, -175.400024,173.999984,164.000030, 0.954999,1.126000,1.019999 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133997,0.005999,-0.011001, -175.400024,173.999984,164.000030, 0.954999,1.005999,1.019999 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142997,0.003999,-0.011001, -175.400024,173.999984,164.000030, 0.954999,0.952999,1.019999 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,0.007999,-0.014001, -175.400024,173.999984,164.000030, 0.954999,0.952999,1.019999 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,-0.023000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.019999 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136997,0.012999,-0.004000, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.019999 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,0.021999,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.019999 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137997,-0.026000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.186997,0.000999,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.187997,-0.014000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.187997,-0.014000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121997,-0.014000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,-0.014000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147997,-0.027000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143997,-0.024000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127997,-0.024000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140997,-0.004000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,-0.014000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152997,0.003999,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166997,-0.022000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157997,-0.022000,-0.013001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156997,-0.028000,-0.013001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154997,-0.028000,-0.015001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154997,-0.021000,-0.015001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.002000,-0.015001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.002000,-0.018001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.009000,-0.018001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142997,-0.005000,-0.018001, -175.400024,173.999984,164.000030, 0.954999,1.061000,1.054000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119997,-0.005000,-0.013001, -175.400024,173.999984,164.000030, 0.954999,0.959000,0.932000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167997,-0.016000,-0.013001, -175.400024,173.999984,164.000030, 0.954999,0.959000,0.932000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167997,-0.016000,-0.019001, -175.400024,173.999984,164.000030, 0.954999,1.028000,0.971000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167997,-0.016000,-0.020001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.028000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125997,0.005999,-0.020001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.028000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125997,0.005999,-0.015001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.028000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125997,0.005999,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150997,-0.024000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150997,-0.022000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133997,-0.018000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156997,-0.018000,-0.019001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167997,-0.018000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141997,0.000999,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.024000,-0.009000, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151997,-0.010000,-0.009000, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163997,0.019999,-0.017001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 138: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.024000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 139: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.024000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.024000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 145: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,-0.014000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 146: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144997,-0.014000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124997,-0.022000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.033000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148997,-0.022000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.178997,-0.028000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,-0.014000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.179997,-0.042000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135997,-0.014000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114997,0.002999,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152997,-0.001000,-0.019001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129997,-0.001000,-0.017001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123997,0.000999,-0.017001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.005000,-0.008000, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.005000,-0.008000, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132997,-0.022000,-0.013001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145997,-0.009000,-0.017001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163997,-0.025000,-0.017001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,-0.016000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167998,-0.029000,-0.016001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.016000,-0.018001, -175.400024,173.999984,164.000030, 0.954999,1.028000,1.059000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.021000,-0.018001, -175.400024,173.999984,164.000030, 0.954999,1.128000,1.059000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,-0.003000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.015999,1.009000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,-0.003000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.015999,1.009000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,-0.006000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.068999,1.009000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.012000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.109999,1.009000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,-0.016000,-0.014001, -175.400024,173.999984,164.000030, 0.954999,1.109999,1.009000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.022000,-0.004000, -175.400024,173.999984,164.000030, 0.954999,1.109999,1.009000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.001000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.109999,1.009000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.016000,-0.012001, -175.400024,173.999984,164.000030, 0.954999,1.109999,1.009000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.028000,-0.016001, -175.400024,173.999984,153.500061, 0.954999,1.109999,1.070000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.037000,-0.020000, -175.400024,173.999984,153.500061, 0.954999,1.109999,1.070000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.023000,-0.017000, -175.400024,173.999984,153.500061, 0.954999,1.109999,1.070000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.033000,-0.019000, -175.400024,173.999984,153.500061, 0.954999,1.109999,1.070000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.162998,-0.041000,-0.019000, -175.400024,173.999984,153.500061, 1.074999,1.109999,1.146000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.023000,-0.019000, -175.400024,173.999984,153.500061, 1.074999,1.109999,1.146000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,-0.002000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.004000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.002999,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,-0.018000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.033000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,-0.025000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,-0.019000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,-0.045000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.014999,1.043999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.175998,-0.039000,-0.006000, -175.400024,173.999984,153.500061, 1.074999,1.139999,1.159999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,-0.041000,-0.013000, -175.400024,173.999984,153.500061, 1.074999,1.139999,1.159999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165998,0.010999,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.178999,1.187999 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114998,-0.015000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.178999,1.187999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,0.012999,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.178999,1.187999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,-0.003000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.178999,1.187999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,-0.006000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.178999,1.187999 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.009000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.178999,1.187999 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.018000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.056999,1.038999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102998,-0.011000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.056999,1.038999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102998,-0.004000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.056999,1.038999 ) ;
			case 237: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,-0.018000,-0.013000, -175.400024,173.999984,169.400070, 1.074999,1.056999,1.038999 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.009000,-0.015000, -175.400024,173.999984,169.400070, 1.074999,1.056999,1.068999 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.011000,-0.015000, -175.400024,173.999984,169.400070, 1.074999,1.101999,1.106000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.187998,-0.023000,-0.011000, -175.400024,173.999984,158.000030, 1.074999,1.101999,1.183000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,-0.010000,-0.020000, -175.400024,173.999984,158.000030, 1.074999,1.101999,1.075000 ) ;
			case 251: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.013000,-0.013000, -175.400024,173.999984,158.000030, 1.074999,1.101999,1.075000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,-0.029000,-0.011000, -175.400024,173.999984,158.000030, 1.074999,1.101999,1.075000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.019000,-0.013000, -175.400024,173.999984,158.000030, 1.074999,1.101999,1.137000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.030000,-0.013000, -175.400024,173.999984,158.000030, 1.074999,1.101999,1.137000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,-0.004000,-0.013000, -175.400024,173.999984,158.000030, 1.074999,0.955999,0.924000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,-0.016000,-0.014000, -175.400024,173.999984,158.000030, 1.074999,0.955999,0.924000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,-0.021000,-0.014000, -175.400024,173.999984,158.000030, 1.074999,1.033999,1.004000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,-0.027000,-0.012000, -175.400024,173.999984,158.000030, 1.074999,1.087999,1.044000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.008000,-0.012000, -175.400024,173.999984,158.000030, 1.074999,1.087999,1.044000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.012000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,1.087999,1.044000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.006000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,1.087999,1.044000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.011000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.013000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.021000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.018000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.018000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.019000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.176998,-0.031000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,-0.015000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.160998,-0.028000,-0.013000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.032000,-0.016000, -175.400024,173.999984,158.000030, 1.074999,0.970999,1.044000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.072000,-0.016000, -175.400024,173.999984,139.900024, 1.074999,0.970999,1.044000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,-0.020000,-0.016000, -175.400024,173.999984,160.200042, 1.074999,1.187999,1.098000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,-0.005000,-0.016000, -175.400024,173.999984,160.200042, 1.074999,1.187999,1.098000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,0.001999,-0.016000, -175.400024,173.999984,160.200042, 1.074999,1.187999,1.098000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.010000,-0.016000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.010000,-0.016000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.010000,-0.012000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.010000,-0.012000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.010000,-0.012000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.010000,-0.012000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.036000,-0.017000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,-0.028000,-0.017000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.036000,-0.014000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.036000,-0.014000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.011000,-0.014000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.011000,-0.014000, -175.400024,173.999984,160.200042, 1.074999,0.985999,1.020999 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115997,0.015000,0.000998, 0.000000,90.000000,85.500000, 1.000000,1.000000,1.000000 ) ;
		}
	}
	else if(type == 7)//°л§пы
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.014000,-0.001001, 0.000000,179.400024,-154.400009, 1.000000,1.000000,1.070000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.014000,-0.001001, 0.000000,179.400024,-154.400009, 1.000000,1.000000,1.070000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.014000,-0.008000, 0.000000,179.400024,-154.400009, 1.000000,1.000000,1.126000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.014000,-0.002001, 0.000000,0.600003,13.600016, 1.000000,1.000000,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.014000,-0.002001, 0.000000,0.600003,-0.099983, 1.000000,1.000000,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.001000,-0.002001, 0.000000,0.600003,-0.099983, 1.000000,1.000000,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.000999,-0.002001, 0.000000,0.600003,-0.099983, 1.000000,1.000000,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.000999,-0.002001, 0.000000,0.600003,-0.099983, 1.000000,1.000000,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,-0.008000,-0.002001, 0.000000,0.600003,-0.099983, 1.000000,1.000000,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.007000,0.003998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119997,-0.027000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.001000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.007999,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.007999,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.004999,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.005000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.000000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.015000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.011000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,-0.006999,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.099998,0.000000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.024000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,-0.004999,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.016000,-0.000001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142998,0.007000,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.037000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.008999,-0.002001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.013000,-0.002001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.028000,0.000998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.009999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.012000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,0.010000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.180998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.008000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.008000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.017000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,-0.004000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.012000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.017000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.006999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.013000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.196998,0.012000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.180998,0.002999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.180998,-0.005000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,-0.005000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,-0.005000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,-0.010000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,-0.012000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.011000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,-0.000000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,-0.004000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.004000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,-0.008000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,-0.013000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,-0.013000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.003999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,-0.003000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,-0.003000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.016000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.023000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.006999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.003000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.004000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.004000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.000999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.010999,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,-0.005000,-0.001001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,-0.005000,0.001998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.174998,0.007999,0.001998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,-0.011000,0.001998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,-0.011000,0.001998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.167998,-0.012000,0.001998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,-0.012000,0.001998, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.174998,-0.022000,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.010999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,0.010999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.000999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.000999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.000999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.000999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.016000,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.007000,-0.005001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,-0.008999,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.001999,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.001999,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.001999,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.001999,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,-0.001999,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.007000,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.007000,-0.003001, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.003000,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,-0.011000,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,-0.011000,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.005000,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.004999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.010999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.010999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.010999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.010999,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.003000,0.002999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.007000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.006000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,0.009000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.001000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.007000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.000000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,-0.010999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.005999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,-0.010999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,-0.020000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.176998,0.017000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,-0.012999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,0.012000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,0.003000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,-0.011000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,-0.011000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,-0.011000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,-0.000000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,-0.000000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.160998,-0.006000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.000000,1.069000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.188998,0.001999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.069000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.001999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.069000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.010000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.069000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.010000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.069000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.002000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.069000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.002000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.146000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.012000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.146000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.011000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,1.031999,1.146000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,-0.002999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,-0.002999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.003999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,-0.003999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.011000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.004000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.004000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.007000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.007000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.007000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.007000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,-0.004999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.956999,1.049000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.168998,0.004000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.990999,1.049000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.004000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.990999,1.049000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.012000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.990999,1.049000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,0.000000,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.990999,1.049000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.008999,0.001999, 0.000000,0.600003,-6.399982, 1.000000,0.990999,1.049000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003999,0.001999, 0.000000,0.600003,-6.399982, 1.075999,1.065999,1.049000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.007999,0.001999, 0.000000,0.600003,-6.399982, 1.075999,1.065999,1.049000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,0.020000,0.001999, 0.000000,0.600003,-6.399982, 1.075999,1.065999,1.049000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146999,0.002000,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.800999,0.970000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146999,0.002000,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154999,0.006000,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154999,0.006000,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154999,0.006000,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154999,0.006000,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150999,-0.004999,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150999,-0.004999,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150999,-0.004999,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
		}
	}
	else if(type == 8)//љереты
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,0.000999,-0.010001, 0.199998,-5.700015,-8.800018, 1.000000,1.000000,1.085000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.000000,-0.001001, 0.199998,-5.700015,-8.800018, 1.000000,1.042000,1.189000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.181998,-0.005000,-0.001001, 0.199998,-5.700015,-8.800018, 1.000000,1.042000,1.189000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.181998,-0.015000,-0.001001, 0.199998,-5.700015,-8.800018, 1.000000,1.042000,1.189000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,0.011999,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.013000,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.013000,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.013000,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.013000,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.011000,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,-0.021999,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,0.002000,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.005999,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,-0.005999,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,-0.005999,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.011000,-0.001001, 0.199998,-5.700015,-8.800018, 1.214000,1.042000,1.196000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.011000,-0.008001, 0.199998,-5.700015,-8.800018, 1.214000,1.137000,1.219000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.011000,-0.008001, 0.199998,-5.700015,-8.800018, 1.214000,1.137000,1.219000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.006000,-0.008001, 0.199998,-5.700015,-8.800018, 1.214000,1.137000,1.219000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.016999,-0.002001, 0.199998,-5.700015,-8.800018, 1.214000,1.137000,1.219000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092998,-0.002999,-0.002001, 0.199998,-5.700015,-8.800018, 1.214000,1.137000,1.219000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120998,0.015000,-0.002001, 0.199998,-5.700015,-8.800018, 1.214000,0.947999,1.029000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120998,-0.002999,-0.002001, 0.199998,-5.700015,-8.800018, 1.074000,1.076999,1.029000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,0.008000,-0.002001, 0.199998,-5.700015,-8.800018, 1.074000,1.076999,1.029000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,0.006000,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.172999,1.123000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,-0.011999,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.172999,1.200000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.012000,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.017000,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,-0.002999,-0.002001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,-0.011999,-0.002001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.181998,0.004000,-0.002001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,-0.005999,-0.002001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,0.002000,-0.002001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.004999,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,0.008000,-0.004001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,0.001000,-0.004001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.013000,-0.004001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.006999,-0.004001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.012000,0.001998, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.012000,0.001998, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.012000,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.022999,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.022999,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.005999,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.014999,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.001000,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.001000,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.015000,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.170998,-0.003999,-0.003001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.170998,-0.007999,0.000998, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.170998,-0.007999,0.000998, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,0.002000,0.000998, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,-0.002999,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,0.000000,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.004000,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.004000,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.004000,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.014999,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.010999,-0.000001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.001999,-0.008001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.001999,-0.004000, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.002000,-0.002000, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003999,-0.006001, 0.199998,-5.700015,-8.800018, 1.074000,1.026999,1.125000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.005000,-0.009000, 0.199998,-5.700015,-8.800018, 1.074000,1.140999,1.169000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.018000,-0.009000, 0.199998,-5.700015,-8.800018, 1.074000,1.140999,1.169000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.020999,0.004999, 0.199998,-5.700015,-8.800018, 1.074000,1.140999,1.169000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.012999,0.004999, 0.199998,-5.700015,-8.800018, 1.074000,1.140999,1.169000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.015999,0.004999, 0.199998,-5.700015,-8.800018, 1.074000,1.140999,1.169000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.015999,0.004999, 0.199998,-5.700015,-8.800018, 1.074000,1.140999,1.169000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,-0.003999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,1.027999,1.079000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.171998,-0.013999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,1.208999,1.217000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.009000,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.160998,0.009000,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.008999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.008999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.002000,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.003999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.009999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.009999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.005999,-0.003000, 0.199998,-5.700015,-8.800018, 1.074000,0.956999,1.109000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.008999,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.183998,-0.008999,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,0.001000,-0.007001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,-0.013999,-0.009001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.002000,-0.009001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.006000,-0.009001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.006000,-0.009001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.002000,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,-0.012999,-0.005001, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,-0.012999,0.000999, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.004999,0.000999, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.010999,0.000999, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.005999,-0.004000, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.010999,-0.004000, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.002999,-0.004000, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.012000,-0.004000, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.012000,-0.004000, 0.199998,-5.700015,-8.800018, 1.074000,1.108999,1.138000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,-0.003999,0.001999, 0.199998,-5.700015,-8.800018, 1.074000,0.936999,0.979000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,0.003000,-0.002000, 0.199998,-5.700015,-8.800018, 1.074000,1.087999,1.135000 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,-0.001999,-0.002000, 0.199998,-5.700015,-8.800018, 1.074000,1.087999,1.135000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.002000,-0.002000, 0.199998,-5.700015,-8.800018, 1.074000,1.087999,1.135000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.177998,-0.007999,0.004999, 0.199998,-5.700015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.175998,-0.019999,-0.000000, 0.199998,-5.700015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,0.012000,-0.000000, 0.199998,-5.700015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,-0.015999,-0.000000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165998,0.012000,-0.002000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165998,0.000000,-0.005000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,-0.018999,-0.001000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,-0.018999,-0.001000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,-0.018999,-0.001000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,-0.006999,-0.001000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.005999,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,0.005000,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,-0.009999,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.000999,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,-0.000999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.012000,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.001999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.004999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.004999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.004999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.004999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.004999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.004999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.004999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.087999,1.222000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.000999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,0.981999,1.143000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.000999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,0.981999,1.143000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.000999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,0.981999,1.143000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.000999,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,0.981999,1.143000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.007000,-0.003000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.171998,0.003000,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.003000,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,0.003000,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,-0.009999,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,-0.017999,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.181998,-0.007999,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,-0.007999,-0.006000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.179998,-0.007999,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,0.004000,-0.004000, 0.199998,-5.500015,-8.800018, 1.074000,1.055999,1.211000 ) ;
		}
	}
	else if(type == 9)//†аски
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.007000,0.012999, 0.000000,173.499969,-154.900054, 1.151999,1.000000,1.145000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.015000,0.012999, 0.000000,173.499969,-149.600036, 1.205000,1.089999,1.200000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.183998,-0.015000,0.012999, 0.000000,173.499969,-149.600036, 1.205000,1.089999,1.200000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,-0.026000,0.008998, 0.000000,173.499969,-149.600036, 1.123000,1.089999,1.200000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.013000,0.008998, 0.000000,173.499969,-149.600036, 1.123000,1.089999,1.200000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.023000,0.009998, 0.000000,173.499969,-149.600036, 1.123000,1.089999,1.200000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.023000,0.009998, 0.000000,173.499969,-149.600036, 1.123000,1.089999,1.200000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,-0.023000,0.006998, 0.000000,177.799987,-149.600036, 1.123000,1.089999,1.200000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,-0.023000,0.006998, 0.000000,177.799987,-149.600036, 1.123000,1.089999,1.200000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.003000,-0.003001, -177.599960,177.799987,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,-0.026000,-0.003001, -177.599960,177.799987,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,0.002999,-0.003001, -177.599960,177.799987,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,-0.002000,-0.003001, -177.599960,177.799987,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.002000,-0.003001, -177.599960,177.799987,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.156998,-0.002000,-0.005001, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.002000,-0.005001, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.002000,-0.005001, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,0.004999,-0.005001, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,-0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,-0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,-0.012999,0.000998, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,-0.012999,0.000998, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121998,0.008000,0.000998, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.008000,0.000998, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.008000,0.000998, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,0.008000,0.000998, -177.599960,179.399978,169.899948, 1.123000,1.089999,1.200000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,-0.019999,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143998,-0.007999,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 50: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.020000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.020000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,-0.020000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,-0.001000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,-0.001000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.007999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.003999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,0.003999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,0.003999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,0.003999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.010000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,0.000999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,0.000999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,0.000999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.018000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,-0.012000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,0.001999,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.003000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.003000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.003000,-0.004001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.003000,-0.009001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.003000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.175998,0.002999,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,-0.002000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146998,-0.002000,-0.006001, -177.599960,179.399978,169.899948, 1.204000,1.089999,1.200000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,-0.011000,-0.005001, -177.599960,179.399978,169.899948, 1.196000,1.089999,1.130000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.162998,-0.011000,-0.005001, -177.599960,179.399978,169.899948, 1.325999,1.204999,1.345000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.016000,-0.005001, -177.599960,179.399978,169.899948, 1.325999,1.204999,1.345000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,-0.016000,-0.005001, -177.599960,179.399978,169.899948, 1.325999,1.204999,1.345000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.016000,-0.005001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.016000,-0.005001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.016000,-0.005001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.007000,-0.005001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147998,-0.024000,0.001998, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.002000,0.001998, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.007000,0.001998, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.007000,-0.008001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.007000,0.002998, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,-0.007000,-0.003001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150998,-0.007000,-0.003001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,-0.007000,-0.003001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.174998,-0.025000,-0.003001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.174998,-0.025000,-0.003001, -177.599960,179.399978,169.899948, 1.247000,1.058999,1.216000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.012000,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.002000,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.002000,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.008000,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141998,-0.008000,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.008000,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.008000,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151998,-0.019999,-0.003001, -177.599960,179.399978,169.899948, 1.228000,1.058999,1.356000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165998,0.013000,-0.003001, -177.599960,179.399978,169.899948, 1.281000,1.058999,1.356000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165998,-0.001999,-0.003001, -177.599960,179.399978,169.899948, 1.281000,1.058999,1.356000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165998,-0.001999,-0.003001, -177.599960,179.399978,169.899948, 1.281000,1.058999,1.356000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,-0.012999,-0.003001, -177.599960,179.399978,169.899948, 1.281000,1.058999,1.356000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,-0.017999,-0.003001, -177.599960,179.399978,169.899948, 1.231000,1.058999,1.273000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,-0.017999,-0.003001, -177.599960,179.399978,169.899948, 1.231000,1.058999,1.273000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132998,-0.007999,-0.003001, -177.599960,179.399978,169.899948, 1.231000,1.058999,1.273000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,-0.002999,-0.003001, -177.599960,179.399978,169.899948, 1.231000,1.058999,1.273000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,-0.002999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.002999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.012999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.012999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.169998,-0.012999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,-0.012999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.012999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.012999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,-0.021999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,-0.021999,-0.003001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.305000,1.058999,1.273000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,-0.007999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,-0.019999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,0.001000,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,-0.002999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.168998,-0.002999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,-0.002999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.008999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154998,-0.009999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,-0.009999,-0.005001, -177.599960,179.399978,169.899948, 1.197000,1.058999,1.191000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.197998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.332000,1.058999,1.191000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.00001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.000000,-0.005001, -177.599960,179.399978,169.899948, 1.054000,1.029999,1.130000 ) ;
		}
	}
	else if(type == 10)//Њарик 1 19519
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079997,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079997,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115998,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096998,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,0.013000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,-0.004999,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,0.015000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,-0.011999,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069998,0.016000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.056998,-0.001000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.070998,-0.001000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093998,0.010999,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,0.012000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.070998,0.025000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.073998,0.015000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.060998,0.015000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.023998,0.003000,0.008999, 0.000000,1.400019,-8.699986, 1.000000,0.953999,0.939999 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067998,0.023000,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.047998,0.015000,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,0.015000,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.062998,0.008000,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,-0.003999,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.010000,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.070998,0.016000,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.056998,-0.014999,0.004998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.022000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.075998,-0.016999,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096998,0.013000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.071998,0.004000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.071998,0.004000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.071998,0.021000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.071998,0.012000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.071998,0.008000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.060998,0.016000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102998,0.016000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102998,0.009000,0.006998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102998,0.009000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.080998,-0.014999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 89: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.068998,-0.001999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.068998,-0.001999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.068998,-0.001999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.068998,-0.018999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,0.002000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,-0.000999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.011000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.011000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074998,0.007000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.063998,-0.000999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.063998,-0.000999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.044998,-0.004999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084998,-0.004999,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.060998,0.011000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.060998,0.011000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.077998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.077998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.077998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.077998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.077998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.018000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.087998,0.018000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.087998,0.018000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067998,0.011000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067998,0.009000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,0.004000,0.001998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.075998,0.004000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.075998,0.026000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.075998,0.039000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.075998,0.018000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,0.018000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 231: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,0.018000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 232: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,-0.023999,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,-0.013999,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.043998,-0.010999,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.043998,-0.002999,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.060998,0.009000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.059998,0.009000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.059998,0.009000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.059998,0.009000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.059998,0.014000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.059998,0.014000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.059998,0.014000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.059998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.061998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.061998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.072998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.005000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.012000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067998,0.012000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067998,0.006000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067998,0.016000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067998,0.012000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.089998,0.000000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.065998,0.002000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.066998,-0.012999,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,0.025000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.076998,0.008000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.076998,0.008000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.076998,0.008000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.076998,0.008000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.076998,0.008000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.076998,0.012000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.070998,0.004000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.070998,0.004000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.070998,0.004000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
		}
	}
	else if(type == 11)//Њарик 19274
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,-0.008000,0.006998, 0.000000,-8.500098,4.799988, 0.871999,0.842000,0.850999 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119997,-0.012000,0.006998, 0.000000,-8.500098,4.799988, 0.871999,0.842000,0.850999 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,-0.017000,0.006998, 0.000000,-8.500098,4.799988, 0.871999,0.842000,0.850999 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,-0.017000,-0.000001, 0.000000,-8.500098,4.799988, 0.871999,0.842000,0.850999 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093998,-0.017000,-0.000001, 0.000000,-8.500098,4.799988, 0.871999,0.842000,0.850999 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093998,-0.017000,-0.000001, 0.000000,-8.500098,4.799988, 0.871999,0.842000,0.850999 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093998,-0.008000,-0.000001, 0.000000,-8.500098,4.799988, 0.871999,0.842000,0.850999 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.082998,-0.033000,-0.000001, 0.000000,-8.500098,-12.200008, 0.871999,0.740000,0.807999 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.082998,0.005000,-0.000001, 0.000000,-8.500098,-12.200008, 0.871999,0.740000,0.807999 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,-0.003999,-0.000001, 0.000000,-3.300096,1.899989, 0.871999,0.740000,0.807999 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112998,-0.003999,-0.000001, 0.000000,-3.300096,1.899989, 0.871999,0.740000,0.807999 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,-0.003999,-0.000001, 0.000000,-3.300096,1.899989, 0.871999,0.740000,0.807999 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,0.002000,-0.000001, 0.000000,-3.300096,1.899989, 0.871999,0.821000,0.807999 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,0.002000,-0.000001, 0.000000,-3.300096,1.899989, 0.871999,0.821000,0.807999 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.043998,-0.013999,-0.000001, 0.000000,-3.300096,1.899989, 0.871999,0.821000,0.807999 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,-0.008999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,-0.008999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,0.004000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,0.004000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096998,0.004000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.089998,-0.005999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.089998,0.016000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,0.000000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084998,-0.008999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.091998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,-0.025999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,0.006000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,0.006000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086998,-0.020999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,-0.010999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.087998,0.004000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,-0.000999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,-0.008999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,-0.021999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,-0.005999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,0.000000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,0.000000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,0.000000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,0.000000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,-0.014999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,-0.003999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,-0.003999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,-0.003999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,-0.003999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.090998,-0.010999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.080998,-0.014999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,-0.010999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.082998,-0.019999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,-0.001999,-0.003001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,-0.012999,-0.003001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,-0.015999,-0.003001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,-0.008999,-0.003001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,-0.008999,-0.003001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,-0.002999,-0.003001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.010999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,0.000000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,-0.007999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.007999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.007999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.002999,-0.004001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.002999,-0.004001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.009999,-0.004001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.009999,-0.004001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,-0.015999,-0.004001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,-0.020999,0.001999, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,-0.010999,0.001999, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,-0.010999,0.001999, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097998,0.001000,0.001999, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.001999,0.001999, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093998,-0.018999,0.001999, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.079998,-0.018999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,-0.005999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,-0.005999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.002000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.002000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.002000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088998,-0.031999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.066998,-0.031999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.077998,-0.019999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.089998,-0.002999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.089998,-0.005999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.089998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,0.006000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,0.006000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,0.006000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.017999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.022999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081998,-0.022999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.091998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.083998,-0.016999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,0.004000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.082998,-0.014999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.001000,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084998,-0.004999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101998,-0.011999,-0.000001, 0.000000,-3.300096,1.899989, 0.786999,0.793000,0.807999 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.070998,0.004000,0.003998, 0.000000,1.400019,-8.699986, 1.000000,0.890000,0.939999 ) ;
  		}
  	}
	else if(type == 12)//Эчки
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.102998,0.030999,-0.001001, 0.000000,90.000000,90.500007, 1.000000,1.058000,1.000000 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.092998,0.039999,-0.001001, 0.000000,90.000000,90.500007, 1.000000,1.058000,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.104998,0.044999,-0.000001, 0.000000,90.000000,90.500007, 1.000000,1.099000,1.080000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.128998,0.026999,-0.001000, 76.200012,73.100074,15.000033, 1.000000,1.130000,1.080000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.128998,0.037999,-0.005000, 138.500000,87.300071,-47.999965, 1.000000,1.217000,1.080000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.105997,0.029999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.017000,1.080000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.098997,0.054999,-0.007000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000 ) ;
			case 8: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088997,0.040999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.066997,0.034999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.081997,0.039999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.076998,0.039999,0.000999, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.076998,0.035999,0.001999, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.082998,0.031999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.094998,0.056999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.079998,0.019999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.098998,0.035999,0.000999, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.081998,0.035999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.102998,0.030999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.093998,0.047999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.093998,0.047999,-0.007000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.102998,0.047999,-0.007000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.037999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.085000,1.080000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.034999,0.000999, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086998,0.036999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 27: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.096998,0.036999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.096998,0.046999,-0.006000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.051999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 31: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.052999,-0.004000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.080998,0.034999,-0.005000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.071998,0.030999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 41: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.079998,0.042999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 42: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.036999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088998,0.041999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,1.029000,1.027000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.095998,0.059999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.093998,0.035999,-0.004000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000 ) ;
			case 50: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.105998,0.012999,-0.008000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085998,0.052999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.092998,0.028999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,0.994000,1.027000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.092998,0.036999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.100000,1.027000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.092998,0.050999,-0.005000, 138.500000,87.300071,-47.999965, 1.000000,1.130000,1.027000 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087998,0.048999,-0.004000, 138.500000,87.300071,-47.999965, 0.880000,0.993001,1.027000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.097998,0.041999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.097998,0.041999,-0.000000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.051999,-0.002000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.070998,0.048999,-0.002000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.055999,0.005999, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.033999,-0.000000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.053999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.045999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.072998,0.041999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.127000,1.027000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.114998,0.023999,0.007999, -121.799896,96.400039,-147.299835, 0.880000,0.983000,1.027000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.094998,0.036999,0.009999, -121.799896,96.400039,-147.299835, 0.880000,0.983000,1.027000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088998,0.042999,-0.000000, -121.799896,96.400039,-147.299835, 0.880000,0.983000,1.027000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.076998,0.046999,-0.000000, -121.799896,96.400039,-147.299835, 0.880000,1.069000,1.027000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.071998,0.040999,-0.000000, -121.799896,96.400039,-147.299835, 0.880000,1.069000,1.027000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.071998,0.051999,-0.001000, -121.799896,96.400039,-147.299835, 0.880000,1.139000,1.027000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.045998,0.024999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,0.950000,1.027000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.084998,0.013999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,0.982000,1.027000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.106998,0.041999,0.000999, -121.599906,96.400039,-147.299835, 0.880000,1.019000,1.027000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.060998,0.040999,0.000999, -121.599906,96.400039,-147.299835, 0.880000,1.019000,1.027000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.094998,0.068999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,1.069000,1.027000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.042999,0.000999, -121.599906,96.400039,-147.299835, 0.880000,1.069000,1.027000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.056999,-0.001000, -121.599906,96.400039,-147.299835, 0.880000,1.069000,1.027000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.050999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,1.116000,1.027000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.050999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,1.150000,1.027000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.098998,0.050999,-0.003000, -121.599906,96.400039,-147.299835, 0.880000,1.150000,1.027000 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.100998,0.039999,-0.003000, -121.599906,96.400039,-147.299835, 1.020000,1.150000,1.027000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085998,0.037999,0.002999, -121.599906,96.400039,-147.299835, 1.020000,1.150000,1.027000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085998,0.044999,-0.004000, -121.599906,96.400039,-147.299835, 1.020000,1.147000,1.027000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085998,0.044999,-0.004000, -121.599906,96.400039,-147.299835, 1.020000,1.126000,1.027000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.108998,0.029999,-0.003000, -92.899909,88.200088,-176.599822, 1.020000,1.079000,1.027000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.095998,0.027999,-0.003000, -92.899909,88.200088,-176.599822, 0.904000,0.976999,1.027000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.109998,0.051999,-0.001000, -92.899909,88.200088,-176.599822, 0.904000,1.115000,1.027000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085998,0.050999,-0.001000, -92.899909,90.100112,-176.599822, 0.904000,1.115000,1.027000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085998,0.050999,-0.001000, -92.899909,90.100112,-176.599822, 0.904000,1.115000,1.027000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.044999,-0.001000, -92.899909,94.700088,-176.599822, 0.904000,1.115000,1.027000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.040999,0.001999, -92.899909,92.700088,-176.599822, 0.904000,1.115000,1.027000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.029999,0.001999, -92.899909,100.800102,-176.599822, 1.055000,1.279000,1.162999 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088998,0.029999,0.001999, -92.899909,100.800102,-176.599822, 1.055000,1.122000,1.093999 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.101998,0.033999,-0.002001, -92.899909,96.000068,-176.599822, 1.055000,1.122000,1.093999 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.033999,-0.002001, -92.899909,92.200057,-174.999862, 1.025000,1.062000,1.093999 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090998,0.033999,-0.000001, -92.899909,92.200057,-175.999877, 1.025000,1.062000,1.093999 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.101998,0.041999,-0.001001, -92.899909,92.200057,-175.999877, 1.025000,1.062000,1.093999 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.101998,0.047999,-0.003000, -92.899909,92.200057,-175.999877, 1.025000,1.062000,1.093999 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.082998,0.029999,0.001999, -92.899909,103.300056,-179.899917, 0.871000,1.031000,1.093999 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.071998,0.037999,-0.002000, -92.899909,103.300056,-174.699890, 0.871000,1.031000,1.093999 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086998,0.025999,-0.002000, -92.899909,103.300056,-173.099945, 0.871000,1.031000,1.093999 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086998,0.049999,-0.005001, -92.899909,103.300056,-176.499954, 0.871000,1.085999,1.093999 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086998,0.031999,0.005999, -92.899909,103.300056,-176.499954, 0.871000,1.085999,1.093999 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.060998,0.045999,0.003999, -92.899909,97.400032,-176.499954, 0.871000,1.085999,1.093999 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.066998,0.043999,0.002999, -92.899909,97.400032,-176.499954, 0.871000,1.085999,1.093999 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.077998,0.023999,0.007999, -92.899909,105.900032,-176.499954, 0.871000,1.085999,1.093999 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.058998,0.040999,-0.002001, -92.899909,96.300025,-176.099960, 0.871000,1.085999,1.093999 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087998,0.052999,-0.005001, -92.899909,96.300025,-177.899948, 0.871000,1.085999,1.093999 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.100998,0.028999,-0.001000, -92.899909,96.300025,-177.899948, 0.871000,1.085999,1.093999 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.096998,0.030999,-0.001000, -92.899909,97.100036,-177.899948, 0.871000,1.085999,1.093999 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.096998,0.035999,-0.001000, -92.899909,97.100036,-177.899948, 0.871000,1.085999,1.093999 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.075998,0.046999,-0.000001, -92.899909,97.100036,-174.299972, 0.871000,1.085999,1.093999 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.074998,0.043999,-0.000001, -92.899909,97.100036,-175.899978, 0.871000,1.085999,1.093999 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.067998,0.040999,-0.000001, -92.899909,97.100036,-175.899978, 0.871000,1.085999,1.093999 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.053999,-0.005001, -92.899909,92.100044,-175.899978, 0.871000,1.069999,1.093999 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.042999,-0.001000, -92.899909,92.100044,-175.899978, 0.871000,1.116999,1.093999 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.067998,0.044999,0.001999, -92.899909,92.100044,-175.899978, 0.871000,1.116999,1.093999 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.095998,0.047999,-0.005001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.095998,0.041999,-0.007001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.095998,0.043999,-0.005001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.099998,0.043999,-0.005001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.122998,0.036999,-0.003000, -92.899909,92.100044,-175.899978, 0.980000,1.043999,1.093999 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.079998,0.033999,-0.003000, -92.899909,92.100044,-175.899978, 0.980000,1.043999,1.093999 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.093998,0.028999,-0.003000, -92.899909,92.100044,-175.899978, 0.980000,1.043999,1.093999 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.050999,-0.006001, -92.899909,92.100044,-175.899978, 0.980000,1.078999,1.093999 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.034999,0.000999, -92.899909,92.100044,-176.700012, 0.980000,1.078999,1.093999 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.075998,0.023999,0.004999, -92.899909,105.300056,-176.700012, 0.980000,1.119999,1.093999 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088998,0.034999,-0.000001, -92.899909,105.300056,-173.700042, 0.980000,1.119999,1.093999 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.092998,0.033999,0.000999, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.092998,0.040999,-0.003000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.092998,0.040999,-0.003000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087998,0.040999,-0.002000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087998,0.037999,-0.001000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087998,0.037999,-0.001000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087998,0.036999,0.000999, -92.899909,92.900062,-176.100021, 0.980000,1.119999,1.093999 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.095998,0.037999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,1.119999,1.093999 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.102998,0.041999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.102998,0.041999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.084998,0.022999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.070998,0.040999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.096998,0.035999,-0.001000, -92.899909,92.900062,-176.100021, 0.839000,0.981999,1.093999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.098998,0.048999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.063998,0.045999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999 ) ;
			case 216: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.063998,0.044999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.093998,0.048999,-0.003001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.068998,0.044999,-0.003001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.054998,0.059999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.096998,0.046999,-0.001001, -92.899909,92.900062,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.053999,-0.001001, -92.899909,92.900062,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.071999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 224: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.061998,0.045999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 225: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.061998,0.045999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.061998,0.045999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.109998,0.057999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.101998,0.068999,-0.000000, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.073998,0.035999,-0.000000, -92.899909,103.200050,-176.100021, 0.839000,1.161999,1.093999 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.055998,0.035999,-0.000000, -92.899909,103.200050,-176.100021, 0.839000,0.999000,1.093999 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.064998,0.048999,-0.000000, -92.899909,93.900032,-176.100021, 0.839000,0.999000,1.093999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.053998,0.027999,-0.000000, -92.899909,93.900032,-176.100021, 0.839000,0.999000,1.093999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.084998,0.038999,-0.000000, -92.899909,93.900032,-176.100021, 0.839000,1.093000,1.093999 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.101998,0.021999,0.004999, -92.899909,106.200004,-176.100021, 0.839000,0.959000,1.093999 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.089998,0.051999,0.000999, -92.899909,87.499969,-176.100021, 0.839000,1.129000,1.093999 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.099998,0.051999,0.000999, -92.899909,96.499946,-176.100021, 0.839000,1.129000,1.093999 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088998,0.062999,-0.001000, -92.899909,96.499946,-176.100021, 0.839000,1.182000,1.093999 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088998,0.054999,-0.004000, -92.899909,96.499946,-176.100021, 0.839000,1.033000,1.093999 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088998,0.045999,0.000999, -92.899909,96.499946,-176.100021, 0.839000,1.033000,1.093999 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.097998,0.048999,-0.001001, -92.899909,96.499946,-176.100021, 0.839000,1.134000,1.093999 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.079998,0.031999,0.005999, -92.899909,96.499946,-176.100021, 0.839000,0.972000,0.954999 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086998,0.057999,0.001999, -92.899909,96.499946,-176.100021, 0.839000,1.079000,1.113999 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086998,0.057999,0.001999, -92.899909,96.499946,-176.100021, 0.839000,1.079000,1.113999 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.094998,0.023999,-0.001001, -92.899909,96.499946,-176.100021, 0.839000,0.945999,1.113999 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.081998,0.048999,-0.002001, -92.899909,88.299957,-177.600051, 0.839000,1.070999,1.113999 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.094997,0.037999,-0.000001, -92.899909,88.299957,-177.600051, 0.839000,1.070999,1.113999 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.103997,0.034999,-0.005001, -92.899909,88.299957,-177.600051, 0.839000,1.097000,1.113999 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.094997,0.036999,-0.001001, -92.899909,97.999961,-175.800079, 0.839000,1.097000,1.113999 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.093997,0.036999,-0.001001, -92.899909,97.999961,-175.800079, 0.839000,1.097000,1.113999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.093997,0.050999,-0.001001, -92.899909,97.999961,-175.800079, 0.839000,1.097000,1.113999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.079997,0.041999,-0.001001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.113999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.088997,0.035999,-0.003001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.113999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.113999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086997,0.033999,-0.001001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.027999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086997,0.037999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085997,0.036999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.082997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.085997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.072997,0.056999,0.007999, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086997,0.034999,-0.000001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.091998,0.050999,-0.000001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.075997,0.032000,-0.005001, 97.999969,81.400047,-4.900008, 0.878000,1.000000,1.000000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.083997,0.038999,-0.008001, 97.999969,81.400047,-4.900008, 0.878000,1.000000,1.000000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.079997,0.045999,-0.000001, 95.799949,87.600059,-4.900008, 0.878000,1.087000,1.000000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.079997,0.040999,-0.000001, 95.799949,67.300048,-4.900008, 0.878000,1.087000,1.000000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090997,0.044999,-0.000001, 95.799949,81.400077,-4.900008, 0.878000,1.087000,1.000000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090997,0.033999,-0.004001, 95.799949,81.400077,-4.900008, 0.878000,1.087000,1.000000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.090997,0.052999,-0.000001, 95.799949,81.400077,-4.900008, 0.878000,1.087000,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.083997,0.033999,-0.002001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.083997,0.033999,-0.002001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087997,0.033999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087997,0.033999,-0.001001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087997,0.033999,-0.001001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.087997,0.033999,-0.001001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.066997,0.048999,-0.004001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.066997,0.048999,-0.004001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.066997,0.048999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.066997,0.048999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086997,0.030999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086997,0.030999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 8, setobject, 2,  0.086997,0.030999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000 ) ;
		}
	}
	else if(type == 13)//љанданы
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.093999,0.018000,0.001999, -86.200012,-1.500002,-96.000038, 1.029999,1.000000,1.006999 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.083999,0.029000,0.001999, -86.200012,-1.500002,-96.000038, 1.029999,1.000000,1.006999 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.104999,0.024000,0.001999, -86.200012,-1.500002,-96.000038, 1.083999,1.000000,1.107000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.131999,0.012999,0.001999, -84.100021,5.999998,-96.600036, 1.268999,1.000000,1.107000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.106999,0.023999,0.001999, -84.100021,5.999998,-96.600036, 1.354999,1.000000,1.107000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.097999,0.006999,0.001999, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.076999,0.028999,-0.001000, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 8: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.076999,0.020999,-0.001000, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.010999,-0.001000, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.024999,-0.001000, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.018999,-0.001000, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.009999,-0.001000, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.014999,-0.001000, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.083999,0.030999,0.000999, -84.100021,5.999998,-96.600036, 1.129999,1.000000,1.041000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,-0.004000,-0.002000, -84.100021,6.599998,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.071999,0.018999,-0.002000, -84.100021,6.599998,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,0.014999,-0.004000, -87.500000,2.199998,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.062999,0.007999,-0.001000, -87.500000,16.199996,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.069999,0.005999,-0.001000, -87.500000,16.199996,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.069999,0.023999,-0.001000, -87.500000,16.199996,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.057999,0.027999,-0.004000, -87.500000,16.199996,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.022999,-0.004000, -87.500000,16.199996,-95.200027, 1.123999,1.000000,1.032000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.003999,-0.002000, -87.500000,16.199996,-95.200027, 1.024999,1.000000,1.032000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.008999,-0.002000, -87.500000,16.199996,-95.200027, 1.024999,1.000000,0.976000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.017999,-0.002000, -87.500000,16.199996,-95.200027, 1.024999,1.000000,0.976000 ) ;
			case 27: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.017999,-0.002000, -87.500000,16.199996,-95.200027, 1.024999,1.000000,0.976000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.025999,-0.006000, -87.500000,16.199996,-95.200027, 1.024999,1.000000,1.039000 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.034999,0.000999, -87.500000,16.199996,-95.200027, 1.024999,1.000000,1.039000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,0.019999,-0.007000, -87.500000,16.199996,-95.200027, 1.062999,1.000000,1.112000 ) ;
			case 31: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,0.022999,-0.006000, -87.500000,16.199996,-95.200027, 1.062999,1.000000,1.112000 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,-0.008000,-0.003000, -87.500000,16.199996,-95.200027, 1.062999,1.000000,0.975000 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.013999,0.009999,-0.000000, -87.500000,16.199996,-95.200027, 0.963999,1.000000,0.975000 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.011999,-0.000000, -87.500000,16.199996,-95.200027, 0.963999,1.000000,0.975000 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.011999,-0.000000, -87.500000,16.199996,-95.200027, 0.963999,1.000000,0.975000 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.011999,-0.000000, -87.500000,16.199996,-95.200027, 0.963999,1.000000,0.975000 ) ;
			case 38: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.032999,-0.000000, -87.500000,16.199996,-95.200027, 0.963999,1.000000,0.975000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.056999,0.018999,-0.002000, -87.500000,16.199996,-95.200027, 0.963999,1.000000,0.975000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.056999,0.006999,-0.001000, -87.500000,16.199996,-95.200027, 1.030999,1.000000,0.975000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012999,0.014999,-0.001000, -87.500000,16.199996,-95.200027, 1.030999,1.000000,0.884000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.065999,0.034999,-0.001000, -87.500000,16.199996,-95.200027, 1.030999,1.000000,0.884000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.018999,-0.003000, -87.500000,16.199996,-95.200027, 1.030999,1.000000,0.934000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.066999,0.033000,-0.004000, -87.500000,16.199996,-95.200027, 1.098999,1.000000,1.053000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.025000,-0.004000, -87.500000,16.199996,-95.200027, 1.098999,1.000000,1.053000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.018000,-0.004000, -87.500000,16.199996,-95.200027, 1.062999,1.000000,1.102000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064999,0.014000,-0.001000, -87.500000,16.199996,-95.200027, 1.062999,1.000000,0.977000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.086999,0.024000,-0.001000, -87.500000,16.199996,-95.200027, 1.062999,1.000000,0.977000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.004000,-0.001000, -87.500000,16.199996,-95.200027, 1.062999,1.000000,0.977000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.017000,-0.001000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,0.977000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.022000,-0.006000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,0.977000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.011000,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,0.977000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.015000,-0.000000, -87.500000,16.199996,-95.200027, 1.069999,1.000000,0.930000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.022000,-0.000000, -87.500000,16.199996,-95.200027, 0.967999,1.000000,0.930000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.048999,0.024000,0.000999, -87.500000,16.199996,-95.200027, 1.033999,1.000000,0.930000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.060999,0.021000,0.002999, -87.500000,16.199996,-95.200027, 1.033999,1.000000,1.000000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.060999,0.026000,0.002999, -87.500000,16.199996,-95.200027, 0.940999,1.000000,0.944000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.060999,0.026000,0.002999, -87.500000,16.199996,-95.200027, 0.940999,1.000000,0.944000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.087999,0.009000,0.007999, -87.500000,16.199996,-95.200027, 0.983999,1.000000,0.944000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.009000,0.007999, -87.500000,16.199996,-95.200027, 0.983999,1.000000,0.944000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.022000,0.002999, -87.500000,16.199996,-95.200027, 0.983999,1.000000,0.944000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.018000,0.002999, -87.500000,16.199996,-95.200027, 0.983999,1.000000,0.944000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.078999,0.008000,-0.002000, -87.500000,16.199996,-95.200027, 0.983999,1.000000,0.944000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.047999,0.017999,-0.000000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,1.020000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.047999,0.010999,-0.000000, -87.500000,16.199996,-95.200027, 1.031999,1.000000,1.020000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.047999,0.018999,-0.000000, -87.500000,16.199996,-95.200027, 1.031999,1.000000,1.020000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,-0.002000,-0.000000, -87.500000,16.199996,-95.200027, 0.877999,1.000000,0.965000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.066999,0.021999,-0.000000, -87.500000,16.199996,-95.200027, 0.877999,1.000000,0.965000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.045999,0.007999,-0.000000, -87.500000,16.199996,-95.200027, 0.986999,1.000000,0.965000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.035000,-0.000000, -87.500000,16.199996,-95.200027, 0.986999,1.000000,1.048000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.022999,-0.000000, -87.500000,16.199996,-95.200027, 0.986999,1.000000,1.048000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.015999,-0.000000, -87.500000,16.199996,-95.200027, 0.986999,1.000000,1.048000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.015999,-0.000000, -87.500000,16.199996,-95.200027, 1.043999,1.000000,1.048000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.024000,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.024000,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.024000,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.019999,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.019999,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.019999,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.019999,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.019999,-0.000000, -87.500000,16.199996,-95.200027, 1.124999,1.000000,1.048000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.010999,-0.000000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,0.984000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.003999,-0.000000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,0.917000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.031999,-0.000000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,1.008000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.027999,-0.005000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,1.046000 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.024999,-0.004000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,1.046000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.024999,-0.007000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,1.046000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.013999,-0.002000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,1.046000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.013999,-0.002000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,1.046000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.019999,-0.002000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,0.968000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.019999,-0.003000, -87.500000,16.199996,-95.200027, 0.987999,1.000000,0.968000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.016999,0.000999, -87.500000,16.199996,-95.200027, 1.072999,1.000000,1.123000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.016999,0.000999, -87.500000,16.199996,-95.200027, 1.072999,1.000000,1.123000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.016999,0.000999, -87.500000,16.199996,-95.200027, 1.117999,1.000000,1.177000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.010999,0.000999, -87.500000,16.199996,-95.200027, 1.023999,1.000000,1.177000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064999,0.016999,0.000999, -87.500000,16.199996,-95.200027, 1.023999,1.000000,0.996000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064999,0.016999,0.000999, -87.500000,16.199996,-95.200027, 1.023999,1.000000,0.996000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064999,0.024999,0.000999, -87.500000,16.199996,-95.200027, 1.023999,1.000000,0.996000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064999,0.035999,0.000999, -87.500000,16.199996,-95.200027, 1.023999,1.000000,0.996000 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064999,0.010999,0.000999, -87.500000,16.199996,-95.200027, 0.912999,1.000000,0.925000 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.023999,0.000999, -87.500000,16.199996,-95.200027, 0.920999,1.000000,0.925000 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,-0.002000,-0.004000, -87.500000,16.199996,-95.200027, 0.920999,1.000000,0.925000 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035999,0.020999,0.000999, -87.500000,16.199996,-95.200027, 0.920999,1.000000,0.925000 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.066999,0.018999,-0.003000, -87.500000,16.199996,-95.200027, 0.997999,1.000000,1.059000 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.057999,0.018999,-0.003000, -87.500000,16.199996,-95.200027, 1.084999,1.000000,1.059000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064999,0.009999,0.005999, -87.500000,16.199996,-95.200027, 1.084999,1.000000,1.059000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.006999,0.000999, -87.500000,16.199996,-95.200027, 1.084999,1.000000,1.059000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.006999,0.000999, -87.500000,16.199996,-95.200027, 1.084999,1.000000,1.059000 ) ;
			case 152: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.006999,0.000999, -87.500000,16.199996,-95.200027, 1.084999,1.000000,1.059000 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.062999,0.014999,0.000999, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.927000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039999,0.014999,-0.002000, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.927000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.023999,-0.006000, -87.500000,16.199996,-95.200027, 0.992999,1.000000,1.068000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.071999,0.024999,0.001999, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.903000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.076999,0.016999,0.001999, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.903000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.076999,0.016999,0.001999, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.903000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.031999,0.001999, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.903000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.020999,0.001999, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.903000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.020999,0.001999, -87.500000,16.199996,-95.200027, 0.992999,1.000000,0.903000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.065999,0.018999,-0.006000, -87.500000,16.199996,-95.200027, 0.992999,1.000000,1.045000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.065999,0.012999,-0.004000, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039999,0.014999,0.000999, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.030999,0.000999, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 174: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.022999,-0.002000, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 175: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.022999,-0.002000, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.022999,-0.002000, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.022999,-0.002000, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.025999,-0.002000, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.020999,-0.004000, -87.500000,16.199996,-95.200027, 1.056999,1.000000,1.045000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.098999,0.019999,-0.004000, -87.500000,16.199996,-95.200027, 0.962999,1.000000,1.014000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.040999,0.019999,-0.004000, -87.500000,16.199996,-95.200027, 0.962999,1.000000,1.014000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.069999,0.009999,-0.004000, -87.500000,16.199996,-95.200027, 0.962999,1.000000,1.014000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.069999,0.026999,-0.004000, -87.500000,16.199996,-95.200027, 0.962999,1.000000,1.014000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.018999,-0.001000, -87.500000,16.199996,-95.200027, 0.962999,1.000000,1.014000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.013999,-0.001000, -87.500000,16.199996,-95.200027, 0.962999,1.000000,1.014000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.013999,0.007999, -87.500000,16.199996,-95.200027, 1.035999,1.000000,1.014000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.025999,0.002999, -87.500000,16.199996,-95.200027, 1.035999,1.000000,1.014000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.016999,-0.001000, -87.500000,16.199996,-95.200027, 1.035999,1.000000,1.014000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.022999,0.000999, -87.500000,16.199996,-95.200027, 1.035999,1.000000,1.014000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.022999,0.000999, -87.500000,16.199996,-95.200027, 1.035999,1.000000,1.014000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.019999,0.000999, -87.500000,16.199996,-95.200027, 1.035999,1.000000,1.014000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.019999,0.000999, -87.500000,16.199996,-95.200027, 0.990999,1.000000,1.014000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.019999,0.000999, -87.500000,16.199996,-95.200027, 0.990999,1.000000,1.014000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.066999,0.015999,0.000999, -87.500000,16.199996,-95.200027, 0.990999,1.000000,1.014000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.019999,0.000999, -87.500000,16.199996,-95.200027, 0.990999,1.000000,1.014000 ) ;
			case 203: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.019999,-0.004000, -87.500000,16.199996,-95.200027, 0.990999,1.000000,1.014000 ) ;
			case 204: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.070999,0.019999,-0.004000, -87.500000,16.199996,-95.200027, 0.990999,1.000000,1.014000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.082000,0.020999,-0.004000, -87.500000,16.199996,-95.200027, 0.990999,1.000000,1.014000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.018999,-0.003000, -87.500000,16.199996,-95.200027, 0.892999,1.000000,1.014000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.007999,-0.000000, -87.500000,16.199996,-95.200027, 0.995999,1.000000,0.883000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.045999,0.026999,-0.002000, -87.500000,16.199996,-95.200027, 0.995999,1.000000,0.883000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.072999,0.024999,-0.003000, -87.500000,16.199996,-95.200027, 0.859000,1.000000,0.883000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.072999,0.038999,-0.003000, -87.500000,16.199996,-95.200027, 0.962999,1.000000,0.883000 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.043999,0.019999,-0.000000, -87.500000,16.199996,-95.200027, 1.060999,1.000000,0.894000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.068999,0.022999,0.000999, -87.500000,16.199996,-95.200027, 0.953999,1.000000,0.894000 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.015000,0.029999,0.000999, -87.500000,16.199996,-95.200027, 0.953999,1.000000,1.113000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,0.015999,0.000999, -87.500000,16.199996,-95.200027, 0.953999,1.000000,1.113000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,0.015999,0.000999, -87.500000,16.199996,-95.200027, 0.953999,1.000000,1.113000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,0.025999,-0.002000, -87.500000,16.199996,-95.200027, 0.953999,1.000000,1.205000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.075999,0.021999,-0.000999, -87.500000,16.199996,-95.200027, 1.115999,1.000000,1.087000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.075999,0.030999,-0.000999, -87.500000,16.199996,-95.200027, 1.115999,1.000000,1.087000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.059999,0.010999,-0.000999, -87.500000,16.199996,-95.200027, 1.115999,1.000000,0.965000 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,0.018999,0.000000, -87.500000,16.199996,-95.200027, 1.033999,1.000000,0.965000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.051999,-0.004000,0.000000, -87.500000,16.199996,-95.200027, 0.905999,1.000000,0.914000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030999,0.003999,0.000000, -87.500000,16.199996,-95.200027, 0.905999,1.000000,0.914000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.028999,0.000000, -87.500000,16.199996,-95.200027, 0.905999,1.000000,0.914000 ) ;
			case 237: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050999,0.009999,0.000000, -87.500000,16.199996,-95.200027, 0.905999,1.000000,0.914000 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.081999,0.015999,0.009000, -87.500000,16.199996,-95.200027, 0.905999,1.000000,0.914000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.016999,0.000000, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.016999,0.000000, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.067999,0.032999,0.000000, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 249: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.058999,0.032999,0.000000, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.058999,0.023999,-0.001999, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055999,0.019999,-0.001999, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.071999,0.020999,-0.001999, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.003999,0.005000, -87.500000,16.199996,-95.200027, 1.009999,1.000000,1.047000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.010999,0.005000, -87.500000,16.199996,-95.200027, 1.129998,1.000000,1.158000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.063999,0.010999,0.005000, -87.500000,16.199996,-95.200027, 1.129998,1.000000,1.158000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.041999,0.014999,-0.001999, -87.500000,16.199996,-95.200027, 0.979998,1.000000,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.052999,0.006999,-0.001999, -87.500000,16.199996,-95.200027, 0.979998,1.000000,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,-0.000000,-0.001999, -87.500000,16.199996,-95.200027, 0.979998,1.000000,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.008999,-0.001999, -87.500000,16.199996,-95.200027, 0.979998,1.000000,1.000000 ) ;
			case 269: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.012999,-0.001999, -87.500000,16.199996,-95.200027, 0.979998,1.000000,1.000000 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.012999,0.000000, -87.500000,16.199996,-95.200027, 0.979998,1.000000,1.000000 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.078999,0.012999,0.000000, -87.500000,16.199996,-95.200027, 0.979998,1.000000,1.000000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.078999,0.019999,0.000000, -87.500000,16.199996,-95.200027, 1.079998,1.000000,1.043000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.006999,0.000000, -87.500000,16.199996,-95.200027, 1.079998,1.000000,1.043000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.006999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.949000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.006999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.949000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.008999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.949000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.012999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.949000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.012999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.949000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.012999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.949000 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.012999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.949000 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.024999,0.004000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,1.064000 ) ;
			case 285: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.016999,0.004000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,1.064000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,-0.001000,-0.002999, -87.500000,16.199996,-95.200027, 0.973998,1.000000,1.064000 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.010999,0.008000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,1.064000 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.005999,-0.000999, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.005999,0.004000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.013999,0.004000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.027999,0.004000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.053999,0.007999,-0.003999, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.069999,0.011999,-0.006999, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.012999,0.003000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.020999,0.001000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.078999,0.020999,0.000000, -87.500000,16.199996,-95.200027, 0.973998,1.000000,0.982000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.078999,0.008999,0.000000, -87.500000,16.199996,-95.200027, 1.062998,1.000000,1.082000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.078999,0.008999,0.000000, -87.500000,16.199996,-95.200027, 1.062998,1.000000,1.082000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.078999,0.017999,0.003000, -87.500000,16.199996,-95.200027, 1.062998,1.000000,1.082000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.011999,0.001000, -87.500000,16.199996,-95.200027, 0.955998,1.000000,0.975000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.011999,0.001000, -87.500000,16.199996,-95.200027, 0.955998,1.000000,0.975000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.011999,0.001000, -87.500000,16.199996,-95.200027, 0.955998,1.000000,0.975000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.011999,0.001000, -87.500000,16.199996,-95.200027, 0.955998,1.000000,0.975000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.011999,0.001000, -87.500000,16.199996,-95.200027, 0.955998,1.000000,0.975000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.061999,0.011999,0.001000, -87.500000,16.199996,-95.200027, 0.955998,1.000000,0.975000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.017999,0.001000, -87.500000,16.199996,-95.200027, 1.059998,1.000000,1.062000 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.017999,-0.001999, -87.500000,16.199996,-95.200027, 0.962998,1.000000,1.062000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.017999,-0.001999, -87.500000,16.199996,-95.200027, 0.962998,1.000000,1.062000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.017999,-0.001999, -87.500000,16.199996,-95.200027, 0.962998,1.000000,1.062000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.006999,-0.001999, -87.500000,16.199996,-95.200027, 0.962998,1.000000,0.949000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.011999,-0.001999, -87.500000,16.199996,-95.200027, 0.962998,1.000000,0.949000 ) ;
			default: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.011999,-0.001999, -87.500000,16.199996,-95.200027, 0.962998,1.000000,0.949000 ) ;
		}
	}
	else if(type == 14)//Наушники
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.286000,0.089000,-0.006000, -90.599975,-121.999969,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.303999,0.089000,-0.006000, -90.599975,-121.999969,92.599967, 1.040000,1.044999,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.293999,0.089000,-0.006000, -90.599975,-121.999969,92.599967, 1.040000,1.044999,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334999,0.089000,-0.006000, -90.599975,-121.999969,92.599967, 1.040000,1.044999,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.355999,0.071000,0.005000, -81.499992,-113.599922,94.599967, 1.099000,1.044999,1.000000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.347999,0.090000,0.000000, -90.599975,-121.999969,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.323998,0.104999,-0.008999, -90.599975,-121.999969,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 8: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.301999,0.112999,0.001999, -90.599975,-121.999969,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.314998,0.089999,0.001999, -90.599975,-108.399971,91.199943, 1.000000,1.000000,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.243998,0.084000,-0.006000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.333998,0.084000,-0.006000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.313999,0.084000,-0.006000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.361999,0.084000,-0.006000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.338999,0.102000,-0.006000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.325999,0.096000,-0.006000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 16: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.367999,0.096000,-0.006000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.346999,0.096000,-0.000999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.299998,0.096000,-0.000999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.354999,0.096000,-0.000999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.336999,0.096000,-0.000999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.336999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.357999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.333999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.333999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.333999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.349999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 27: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.338999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.343999,0.096000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342999,0.102000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.294999,0.092000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.348999,0.108000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.328999,0.108000,-0.004999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.324999,0.101000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.324999,0.101000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 38: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.251999,0.101000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.251999,0.101000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.298999,0.086000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.277999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.277999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.299999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.323999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.343999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.354999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.278999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.319999,0.100000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.344999,0.109000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.319999,0.109000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327999,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327999,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327999,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327999,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327999,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.333999,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.320999,0.094000,0.001000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.320999,0.094000,0.001000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.329998,0.094000,0.001000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.380998,0.109999,0.003000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.364998,0.109999,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.100000,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.100000,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.328998,0.094999,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.260998,0.094999,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.266998,0.098999,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.360998,0.098999,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.311998,0.098999,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.318998,0.098999,0.000000, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.341998,0.098999,-0.002999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331998,0.102999,-0.008999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.366998,0.082000,-0.000999, -90.599975,-104.999977,92.599967, 1.000000,1.000000,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326998,0.100999,-0.005999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326998,0.100999,-0.005999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334998,0.100999,-0.005999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334998,0.100999,-0.005999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334998,0.100999,-0.005999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.360998,0.100999,-0.005999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.309998,0.084999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.332998,0.103999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.339998,0.103999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.335998,0.103999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.335998,0.103999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.304998,0.087999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.304998,0.087999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327998,0.087999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327998,0.087999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.339998,0.093999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.329998,0.091999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.329998,0.091999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.097999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.335998,0.097999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.335998,0.097999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.335998,0.103999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.316998,0.103999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.247998,0.103999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.247998,0.099999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.319998,0.089999,0.002000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.319998,0.089999,0.002000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.339998,0.097999,0.002000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.348998,0.109000,0.002000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.322998,0.109000,0.007000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.322998,0.095000,0.002000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.322998,0.095000,0.002000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.322998,0.110000,0.008000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.312998,0.110000,-0.004999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.110000,-0.010999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327998,0.110000,-0.005999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.303998,0.098000,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.361998,0.098000,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.355998,0.107000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.271998,0.092000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.271998,0.092000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.092000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.092000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.092000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.102000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 174: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.102000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 175: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.102000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.102000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.102000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.102000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.102000,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.086000,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326998,0.103999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.333998,0.103999,-0.001999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.103999,-0.006999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.330998,0.090999,-0.006999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.330998,0.090999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.329998,0.111999,0.013000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.329998,0.099999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326998,0.099999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.090999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.090999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.090999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.340998,0.090999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.358998,0.101999,0.000000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331998,0.098999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.324998,0.098999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.324998,0.098999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.318998,0.098999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.256998,0.098999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.330998,0.098999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.252998,0.098999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.327998,0.103999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.322998,0.091999,0.003000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.322998,0.091999,0.003000, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.351998,0.111999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.351998,0.111999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.092999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.361998,0.096999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331998,0.109999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.274998,0.109999,-0.003999, -90.599975,-104.999977,92.599967, 1.033000,1.000000,1.000000 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.301998,0.101999,-0.003999, -90.599975,-104.999977,92.599967, 1.109000,1.000000,1.000000 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.336998,0.093999,-0.003999, -90.599975,-104.999977,92.599967, 0.950000,0.974000,1.000000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.277998,0.093999,-0.003999, -90.599975,-104.999977,92.599967, 0.950000,0.974000,1.000000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.268998,0.093999,-0.003999, -90.599975,-104.999977,92.599967, 0.950000,0.974000,1.000000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.274998,0.093999,-0.003999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.387998,0.111999,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.325998,0.087999,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.345998,0.103999,-0.007999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.345998,0.103999,-0.007999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334998,0.103999,-0.002999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334998,0.103999,-0.005999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334998,0.103999,-0.005999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.332998,0.103999,0.009000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.348998,0.103999,0.001000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.348998,0.103999,0.001000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.276998,0.103999,0.001000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.317998,0.083999,0.001000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.317998,0.083999,-0.004999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.304998,0.070999,-0.004999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.531998,0.082000,-0.039000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 269: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.368998,0.068000,-0.007999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.355998,0.091000,-0.007999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.339998,0.094000,0.002000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.334998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.315998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.094000,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.104999,-0.001999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 285: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.342998,0.090999,0.002000, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.337998,0.086999,-0.003999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.345998,0.097999,-0.000999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.341998,0.097999,-0.000999, -90.599975,-104.999977,92.599967, 1.022999,0.974000,1.000000 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.307996,0.097000,-0.000999, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.307996,0.097000,0.002001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.307996,0.097000,0.002001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.328996,0.074000,0.002001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.338996,0.084000,0.002001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.338996,0.084000,0.002001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.260996,0.084000,0.002001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.260996,0.093999,0.007001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.318996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.312996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331996,0.099999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331996,0.099999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331996,0.099999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331996,0.099999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331996,0.099999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.331996,0.099999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 9, setobject, 1, 0.326996,0.093999,0.000001, -94.199966,-113.199882,85.200004, 1.000000,1.000000,1.000000 ) ;
		}
	}
	else if(type == 15)// Часы
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.003998,-0.001999, 51.200016,53.199977,142.800018, 0.963999,0.916999,1.000000 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.001999,-0.005999, 51.200016,53.199977,142.800018, 1.226999,1.173999,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.001999,-0.007999, 51.200016,53.199977,142.800018, 1.226999,1.173999,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.001999,-0.012999, 51.200016,53.199977,142.800018, 1.226999,1.173999,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.011000,-0.018998,-0.000999, 51.200016,70.499969,142.800018, 1.354999,1.441999,1.000000 ) ;
			case 8: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.011000,-0.003998,-0.011999, 51.200016,70.499969,142.800018, 1.354999,1.441999,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.011000,-0.007998,-0.001999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.011000,-0.007998,-0.001999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.011000,-0.007998,-0.001999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.002998,-0.015999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.010998,-0.012999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.006998,-0.006999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.006998,-0.006999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.006998,-0.006999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.018999,-0.009998,-0.011999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.010999,-0.008998,-0.008999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.010999,-0.008998,-0.008999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.010999,-0.008998,-0.005999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.010999,-0.003998,-0.005999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 31: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.010999,-0.003998,-0.005999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.010999,-0.003998,0.008001, 51.200016,70.499969,142.800018, 0.964999,0.921999,1.000000 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.010999,-0.003998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.054000,-0.003998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.054000,-0.003998,-0.015999, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.054000,-0.003998,-0.015999, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 38: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.024000,-0.003998,-0.015999, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.024000,-0.003998,-0.010998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 41: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.004000,-0.005998,0.001001, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 42: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.004000,-0.005998,-0.012998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.004000,-0.005998,-0.001998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.004000,-0.005998,-0.001998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.004000,-0.015998,-0.008998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.004000,-0.008998,-0.008998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.004000,0.001001,-0.000998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,0.001001,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.007998,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 51: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.010998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 52: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.010998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 53: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.003998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.003998,-0.001998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.003998,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.026999,0.005001,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003000,-0.003998,-0.007998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003000,-0.011998,-0.004998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003000,-0.002998,-0.000998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.011999,-0.014998,-0.000998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.008998,-0.007998, 51.200016,70.499969,142.800018, 1.271999,1.359999,1.000000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.008998,-0.007998, 51.200016,70.499969,142.800018, 1.271999,1.359999,1.000000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.008998,-0.004998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.008998,-0.004998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.010998,-0.004998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.010998,-0.003998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.014998,-0.005998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.014998,-0.005998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000 ) ;
			case 88: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,0.001001,-0.028998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.004998,-0.007998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.004998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.004998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.009998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.001998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.017998,-0.008998, 51.200016,70.499969,142.800018, 1.093999,1.223999,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.040998,-0.008998, 51.200016,70.499969,142.800018, 1.093999,1.223999,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.002998,0.001001, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.002998,-0.002998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.007998,-0.006998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.003998,-0.004998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.009999,0.001001,-0.001998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.026999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.363999,1.386999,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.026999,0.000001,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.014999,0.000001,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.014999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.014999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.014999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.022999,-0.008998,-0.012998, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.001998,0.001001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.001998,0.001001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.006000,-0.009998,-0.003998, 51.200016,70.499969,142.800018, 1.128999,1.127999,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.004999,-0.007998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.004999,-0.001998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.004999,-0.010998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.004999,-0.010998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.007000,-0.010998,-0.010998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.007000,-0.004998,-0.005998, 51.200016,70.499969,142.800018, 1.232999,1.202999,1.000000 ) ;
			case 129: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.024999,-0.005998,-0.005998, 51.200016,70.499969,142.800018, 1.232999,1.202999,1.000000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.009999,-0.011998,0.013001, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000 ) ;
			case 133: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.009999,-0.005998,-0.008998, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.009999,-0.012998,-0.005998, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.004998,-0.001998, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.004998,-0.001998, 51.200016,70.499969,142.800018, 0.984000,0.977999,1.000000 ) ;
			case 149: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.015998,-0.001998, 51.200016,70.499969,142.800018, 1.120999,1.087999,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.010998,-0.005998, 51.200016,70.499969,142.800018, 1.120999,1.087999,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.013998,-0.005998, 51.200016,70.499969,142.800018, 1.120999,1.087999,1.000000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.000998,-0.005998, 51.200016,70.499969,142.800018, 1.250000,1.087999,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.009999,-0.000998,-0.009998, 51.200016,70.499969,142.800018, 1.064000,1.210999,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.021000,-0.009998,-0.008998, 51.200016,70.499969,142.800018, 1.064000,1.210999,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.021000,-0.009998,-0.003998, 51.200016,70.499969,142.800018, 1.212000,1.210999,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.021000,-0.009998,-0.003998, 51.200016,70.499969,142.800018, 1.212000,1.210999,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.021000,-0.004998,-0.004998, 51.200016,70.499969,142.800018, 1.310000,1.304999,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.021000,-0.001998,-0.004998, 51.200016,70.499969,142.800018, 1.310000,1.304999,1.000000 ) ;
			case 167: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.021000,-0.010998,-0.013999, 51.200016,70.499969,142.800018, 1.310000,1.304999,1.000000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.005998,-0.004998, 51.200016,70.499969,142.800018, 1.016000,1.304999,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.005998,0.002001, 51.200016,70.499969,142.800018, 1.292000,1.304999,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.005998,-0.007998, 51.200016,70.499969,142.800018, 1.292000,1.304999,1.000000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.008998,0.001001, 51.200016,70.499969,142.800018, 0.956000,1.095999,1.000000 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.006998,0.000001, 51.200016,70.499969,142.800018, 1.195000,1.197999,1.000000 ) ;
			case 174: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.195000,1.197999,1.000000 ) ;
			case 175: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.450000,1.353999,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.001998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.001998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.017998,-0.008998, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.011998,-0.001998, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.008998,-0.010999, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.001998,0.000000, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.007998,-0.008999, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.007998,-0.008999, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 196: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.003998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 198: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.014998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.021999,-0.008998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 201: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.021999,-0.008998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.007998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.007998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.007998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 209: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.007998,0.008000, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.007998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.011998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.011998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 215: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.006998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 216: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.006998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.003998,-0.003999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.010998,-0.003999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000 ) ;
			case 224: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000 ) ;
			case 225: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.003998,-0.006999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000 ) ;
			case 231: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.003998,-0.006999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.006998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.006998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.012998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.012998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.012998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.009998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.002998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.008998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 263: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 269: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.004998,0.005001, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.009000,-0.008998,-0.006999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.020000,-0.013998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.008000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 285: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.001000,-0.002998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.008998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.015000,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 7, setobject, 6, 0.001999,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.050999,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.028999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 7, setobject, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000 ) ;
		}
	}
	else if(type == 16)//Цюкзаки 1
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.204000,-0.064999,-0.002999 ,  -0.600000,-1.100000,0.000000 ,  1.075999,0.918998,0.905000  ) ;
			case 2: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.237000,-0.064999,-0.002999 ,  -0.600000,-1.100000,0.000000 ,  1.075999,0.918998,0.905000  ) ;
			case 3: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.228000,-0.062999,-0.002999 ,  -0.600000,-1.100000,0.000000 ,  1.075999,0.918998,0.905000  ) ;
			case 4: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.194000,-0.056999,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,0.918998,0.905000  ) ;
			case 5: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.194000,-0.117999,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,1.000998,0.905000  ) ;
			case 6: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.194000,-0.079999,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,1.000998,0.905000  ) ;
			case 7: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.219000,-0.057999,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,1.000998,0.905000  ) ;
			case 8: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.207000,-0.061999,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.962998,0.834000  ) ;
			case 9: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.207000,-0.058999,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.962998,0.834000  ) ;
			case 10: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.262000,-0.071999,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.962998,0.834000  ) ;
			case 11: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.189000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 12: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.184000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 13: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.116000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 14: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.158000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 15: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.153999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 17: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.156000,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 18: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.184999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 19: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.129999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 20: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.159999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 21: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.159999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 22: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.243000,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 23: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.167000,-0.077000,-0.014999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 24: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.145000,-0.077000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 25: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.145000,-0.077000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 28: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.145000,-0.077000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 29: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.188000,-0.103000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 30: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.188000,-0.103000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 31: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.239000,-0.103000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 32: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.173000,-0.068999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 33: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.199000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 34: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.150000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 35: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.161000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 36: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.161000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 37: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.161000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 38: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.222000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 39: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.222000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 40: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.172000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 41: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.172000,-0.067000,-0.017999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 42: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.172000,-0.067000,-0.017999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 43: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.196000,-0.067000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 44: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.203000,-0.067000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 45: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.171999,-0.067000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 46: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 47: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 48: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 49: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 50: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 53: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.218999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 54: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.232999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 55: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.174999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 56: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.174999,-0.074000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 57: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.116999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 58: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.202999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 59: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 60: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 61: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 62: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 65: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.115999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 66: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 67: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 68: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 69: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.141999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 70: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.146999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 71: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.146999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 72: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.155999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 73: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.167999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 76: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.162999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 77: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.207999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 78: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.118999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 79: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 82: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.156999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 83: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.136999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 84: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.136999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000  ) ;
			case 86: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.888999  ) ;
			case 88: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.124999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.911998,0.753999  ) ;
			case 89: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.124999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.911998,0.753999  ) ;
			case 90: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.048999,-0.057000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.999998,0.826000  ) ;
			case 91: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.048999,-0.057000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000  ) ;
			case 93: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.048999,-0.067000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000  ) ;
			case 94: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.122999,-0.067000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000  ) ;
			case 95: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.113999,-0.067000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000  ) ;
			case 96: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.022999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000  ) ;
			case 97: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.071999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000  ) ;
			case 98: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.058999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.806000  ) ;
			case 100: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.046999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.806000  ) ;
			case 101: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.046999,-0.112000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.853998,0.900000  ) ;
			case 102: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.055999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.853998,0.900000  ) ;
			case 103: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.055999,-0.123000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 104: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.097999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 105: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.035999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 106: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.088999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 107: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.093999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 108: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 109: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 110: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 111: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.051999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000  ) ;
			case 112: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.107999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 113: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 114: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 115: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.082999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 116: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.082999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 117: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.105999,-0.080000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 118: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.105999,-0.080000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 119: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.105999,-0.080000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 120: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.105999,-0.080000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 121: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.084999,-0.101000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 122: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.084999,-0.101000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 123: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.098999,-0.101000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 124: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.096999,-0.076000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 125: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.096999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 126: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.096999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 127: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.105999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 128: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.112999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 129: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.186999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 130: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.153999,-0.085000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 131: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.078999,-0.069000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 132: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.175999,-0.069000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 133: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.089999,-0.078000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 134: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.156999,-0.064000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 135: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.093999,-0.094000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000  ) ;
			case 136: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.161999,-0.082000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 137: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.111999,-0.086000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 142: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.076999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 143: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.084999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 144: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.084999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 146: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.084999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 147: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.099999,-0.068000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 148: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.099999,-0.068000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 150: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.099999,-0.060000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 151: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.099999,-0.081000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 152: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.115999,-0.064000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 153: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.089999,-0.072000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 154: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.107999,-0.072000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 155: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.086000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 156: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.083999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 157: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.089999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 158: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.089999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 159: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.089999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 160: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.105999,-0.065000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 161: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.067999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 162: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 163: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.050999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 164: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.050999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 165: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.127999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 166: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.127999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 170: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.065999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 171: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.084999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 172: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.095999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 173: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 174: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 175: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 176: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 177: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 179: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 180: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.079999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 181: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.066999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 182: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.088999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 183: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.088999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 184: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.078999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 185: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.092999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 186: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.092999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 187: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.092999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 188: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.083999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 189: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.094999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 190: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.058999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 191: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.058999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 192: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.065999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 193: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.065999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 194: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 195: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.044999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 198: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.075999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 200: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.078999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 201: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.078999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 202: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 203: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 204: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 206: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.075999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 207: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 208: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.095999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 210: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.154999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 211: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.063999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 212: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.148999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 213: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.078999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 214: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 215: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 216: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 217: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.078999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 219: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.083999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 220: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 221: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 222: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 223: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 224: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 225: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 226: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.103999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 227: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.043999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 228: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.068999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 229: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.139999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 230: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.103999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 233: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.067999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 234: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.131999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 235: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.131999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 236: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.131999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 239: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.045999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 240: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.085999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 247: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.072999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 248: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.075999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 250: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.078999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 252: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.063999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 253: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.113999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 254: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.062999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 255: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 258: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 259: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.077999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 261: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.130999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 262: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.082999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 263: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.088999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 265: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.089999,-0.078000,-0.011999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 266: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.097999,-0.078000,-0.011999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 267: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   0.121000,-0.078000,-0.030000 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 269: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.064999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 270: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.064999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 271: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 272: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.102999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 273: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.109999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 274: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.066999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 275: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.066999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 276: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.066999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 280: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.065999,-0.090000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 281: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.073999,-0.090000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 282: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.080999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 283: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.080999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 284: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.088999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 285: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.069999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 286: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.069999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 287: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.073999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 288: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.073999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 289: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.079999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 290: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.079999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 291: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.084999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 292: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.057999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 293: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.060999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 294: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.070999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 295: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.135999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 296: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.130999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 297: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.082999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 298: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.082999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 299: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.050999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 300: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 301: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 302: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 303: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 304: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 305: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 306: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 307: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 308: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 309: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 310: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			case 311: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
			default: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
		}
	}
	else if(type == 17)//Цюкзаки 2
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.008999,-0.116999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.087999,-0.116999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.041999,-0.116999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.116999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.181999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.012000,-0.139999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.008999,-0.139999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 8: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.122999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.107999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.077999,-0.127999,-0.013000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.030000,-0.105999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.033999,-0.099999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.048000,-0.099999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.010000,-0.091999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.010000,-0.091999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.091999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.091999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.091999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.091999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.108999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.108999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.108999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.108999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.108999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019000,-0.108999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.021999,-0.126999,-0.007999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.114999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.114999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.114999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.114999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.114999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.114999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.114999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.105999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 41: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.105999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 42: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.105999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.098999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.018999,-0.084999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.018999,-0.084999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.011000,-0.109999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.011000,-0.118999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.032000,-0.118999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.032000,-0.109999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 53: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.066999,-0.109999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.066999,-0.109999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.008999,-0.097999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.008999,-0.087999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.037000,-0.125999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.038999,-0.099999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.011000,-0.099999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.117999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.007999,-0.117999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.020999,-0.106999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 65: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.010000,-0.103999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.010000,-0.122999,-0.003000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.010000,-0.122999,-0.003000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.010000,-0.122999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.031000,-0.115999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.013999,-0.115999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.046000,-0.123999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.007999,-0.123999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.002000,-0.123999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.017999,-0.116999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 77: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.051999,-0.116999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.048000,-0.113999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.008999,-0.113999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.024000,-0.113999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.039000,-0.113999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.039000,-0.113999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 85: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.002000,-0.113999,-0.010999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.023999,-0.121999,-0.005999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 88: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.049999,-0.111999,-0.005999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.009000,-0.094999,-0.005999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.009000,-0.109999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.067999,-0.109999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.030999,-0.109999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.045000,-0.120999,-0.006999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.107999,-0.006999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.107999,-0.006999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.101999,-0.006999, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.140999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.026999,-0.131999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.026999,-0.159999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.044999,-0.156999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.012999,-0.170999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.049999,-0.147999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.049999,-0.147999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.096999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.008000,-0.114999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.008000,-0.114999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.008000,-0.123999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.022999,-0.123999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.041999,-0.123999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.123999,-0.012000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.135999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.135999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.126999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.126999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.126999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.126999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.126999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.116999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.005999,-0.116999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.029000,-0.102999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.029000,-0.102999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.029000,-0.102999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.102999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.093999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.050999,-0.093999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 133: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.017000,-0.094999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.035999,-0.091999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.035999,-0.127999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.035999,-0.098999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.018999,-0.089999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018000,-0.084999,-0.004000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.084999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.084999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.100999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.100999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.087999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.135999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 152: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.095999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.095999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.095999,-0.014000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.006999,-0.122999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.001000,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 158: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.001000,-0.105999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 159: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.001000,-0.105999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.001000,-0.093999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 161: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.102999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.042000,-0.107999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.042000,-0.107999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.045999,-0.107999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.045999,-0.107999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 167: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.107999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 168: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.107999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.086999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.087999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.022000,-0.087999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 174: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.022000,-0.087999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 175: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.022000,-0.087999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.022000,-0.119999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.022000,-0.119999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.022000,-0.106999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.022000,-0.107999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.035000,-0.106999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.109999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.109999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.000999,-0.109999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.040000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.040000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.023000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 196: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.047999,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 198: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.030000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 199: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.067999,-0.101999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.007000,-0.101999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 201: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.021000,-0.094999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.021000,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.021000,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.021000,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.021000,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.021000,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.033999,-0.100999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.033999,-0.120999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.015999,-0.108999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 215: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.015999,-0.108999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 216: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.015999,-0.108999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.015999,-0.108999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004000,-0.103999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.027999,-0.130999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.027999,-0.130999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.027999,-0.130999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.035000,-0.130999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.024999,-0.087999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018000,-0.116999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018000,-0.099999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.030999,-0.085999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.003999,-0.085999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.024000,-0.093999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.013999,-0.080999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.013999,-0.080999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.013999,-0.080999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.026000,-0.110999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.003999,-0.110999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 241: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.003999,-0.124999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 242: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.003999,-0.124999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 243: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.003999,-0.110999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.031999,-0.110999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.004999,-0.110999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.008000,-0.110999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.068000,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 253: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.010999,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.023999,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.023999,-0.098999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.016000,-0.116999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.002999,-0.111999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.039999,-0.111999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.039999,-0.111999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.022999,-0.120999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.022999,-0.120999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.231000,-0.120999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004999,-0.120999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 269: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004999,-0.157999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004999,-0.129999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.004999,-0.129999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.033000,-0.116999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.010000,-0.116999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.051999,-0.123999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.051999,-0.123999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.051999,-0.123999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.040999,-0.123999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.040999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.040999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.040999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.005999,-0.117999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 285: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.019999,-0.130999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.002000,-0.136999,-0.008000, 0.000000,87.699974,0.000000, 1.075999,1.079998,1.029000 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.054000,-0.133000,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.054000,-0.133000,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018000,-0.133000,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018000,-0.133000,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.001000,-0.127999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.048000,-0.108999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.055000,-0.119000,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.041000,-0.130999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.073999,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.073999,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.008000,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.048000,-0.106999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.048000,-0.123999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.117999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.108999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.108999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.108999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.108999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018000,-0.120999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018000,-0.120999,0.000000, 0.000000,90.000000,0.000000, 1.052999,0.896999,0.982001 ) ;
			default: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
		}
	}
	else if(type == 18)//Цюкзаки 3
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.089999,-0.054999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.120000,1.079998,1.029000  ) ;
			case 2: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.085000,-0.054999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.120000,1.079998,1.029000  ) ;
			case 3: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.085000,-0.054999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.120000,1.079998,1.029000  ) ;
			case 4: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.046999,-0.002000 ,  0.000000,90.000000,0.000000 ,  1.067000,1.079998,1.029000  ) ;
			case 5: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.078000,-0.047999,-0.002000 ,  0.000000,90.000000,0.000000 ,  1.330000,1.319998,1.228000  ) ;
			case 6: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.095000,-0.047999,-0.002000 ,  0.000000,90.000000,0.000000 ,  0.978000,1.154998,1.164000  ) ;
			case 7: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.049000,-0.039000,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.084000,1.154998,1.164000  ) ;
			case 9: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062000,-0.039000,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.942000,1.184998,1.164000  ) ;
			case 11: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.077000,-0.039000,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.942000,1.184998,1.164000  ) ;
			case 12: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.052000,-0.048999,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.869000,1.184998,1.164000  ) ;
			case 13: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.093000,-0.035999,-0.006000 ,  0.000000,90.000000,0.000000 ,  0.869000,1.184998,1.164000  ) ;
			case 14: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.078000,-0.044999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.005000,1.184998,1.164000  ) ;
			case 15: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.078000,-0.044999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.005000,1.184998,1.164000  ) ;
			case 17: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.078000,-0.039999,-0.002000 ,  0.000000,90.000000,0.000000 ,  1.005000,1.184998,1.164000  ) ;
			case 18: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.078000,-0.039999,-0.002000 ,  0.000000,90.000000,0.000000 ,  0.979000,1.042998,1.093000  ) ;
			case 19: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.108000,-0.039999,-0.002000 ,  0.000000,90.000000,0.000000 ,  0.979000,1.042998,1.093000  ) ;
			case 20: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.014999,-0.002000 ,  0.000000,90.000000,0.000000 ,  0.979000,1.042998,1.093000  ) ;
			case 21: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.014999,-0.002000 ,  0.000000,90.000000,0.000000 ,  1.012000,1.071998,1.093000  ) ;
			case 22: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.025999,-0.002000 ,  0.000000,90.000000,0.000000 ,  1.078000,1.071998,1.093000  ) ;
			case 23: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.025999,-0.002000 ,  0.000000,90.000000,0.000000 ,  0.951000,1.071998,1.093000  ) ;
			case 24: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.025999,-0.002000 ,  0.000000,90.000000,0.000000 ,  1.062000,1.173999,1.093000  ) ;
			case 25: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.025999,-0.002000 ,  0.000000,90.000000,0.000000 ,  1.062000,1.173999,1.093000  ) ;
			case 28: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.033999,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.119000,1.173999,1.093000  ) ;
			case 30: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.033999,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.119000,1.173999,1.093000  ) ;
			case 32: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.058000,-0.008000 ,  0.000000,90.000000,0.000000 ,  0.885001,1.006999,1.093000  ) ;
			case 34: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.027000,-0.008000 ,  0.000000,90.000000,0.000000 ,  0.885001,1.006999,1.093000  ) ;
			case 35: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.027000,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.068001,1.003999,1.093000  ) ;
			case 36: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.027000,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.068001,1.003999,1.093000  ) ;
			case 37: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.027000,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.068001,1.003999,1.093000  ) ;
			case 43: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.027000,-0.008000 ,  0.000000,90.000000,0.000000 ,  0.965001,0.922999,0.975000  ) ;
			case 44: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082000,-0.027000,-0.008000 ,  0.000000,90.000000,0.000000 ,  0.917001,0.961999,0.894000  ) ;
			case 45: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.103000,-0.017000,-0.008000 ,  0.000000,90.000000,0.000000 ,  0.917001,0.961999,0.894000  ) ;
			case 46: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.103000,-0.030000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.100000,1.024998,0.999000  ) ;
			case 47: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.090000,-0.030000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.100000,1.024998,0.999000  ) ;
			case 48: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.090000,-0.030000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.100000,1.024998,0.999000  ) ;
			case 57: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.146999,-0.030000,-0.004000 ,  0.000000,90.000000,0.000000 ,  0.962001,0.902998,0.999000  ) ;
			case 58: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.057999,-0.030000,-0.004000 ,  0.000000,90.000000,0.000000 ,  0.851001,0.902998,0.999000  ) ;
			case 59: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.057999,-0.030000,-0.004000 ,  0.000000,90.000000,0.000000 ,  0.972001,1.047998,1.178999  ) ;
			case 60: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.057999,-0.009000,-0.004000 ,  0.000000,90.000000,0.000000 ,  0.972001,1.047998,1.178999  ) ;
			case 61: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.040999,-0.029000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.036001,0.948998,1.219999  ) ;
			case 68: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.040999,-0.020000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.036001,0.948998,1.219999  ) ;
			case 70: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.063999,-0.020000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.082001,1.035998,1.219999  ) ;
			case 71: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.063999,-0.031000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.082001,1.035998,1.219999  ) ;
			case 72: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.063999,-0.040000,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.082001,1.035998,1.219999  ) ;
			case 73: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.091000,-0.050999,0.000000 ,  0.000000,90.000000,0.000000 ,  1.096999,0.971998,1.035001  ) ;
			case 78: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.102999,-0.031999,0.008000 ,  0.000000,90.000000,0.000000 ,  1.096999,0.971998,1.138001  ) ;
			case 79: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.085999,-0.036998,0.008000 ,  0.000000,90.000000,0.000000 ,  1.096999,1.117999,1.138001  ) ;
			case 86: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.085999,-0.072999,0.002999 ,  0.000000,90.000000,0.000000 ,  1.096999,1.117999,1.138001  ) ;
			case 94: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.022999,-0.043999,0.002999 ,  0.000000,90.000000,0.000000 ,  0.933999,1.000999,1.138001  ) ;
			case 95: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.022999,-0.043999,-0.005000 ,  0.000000,90.000000,0.000000 ,  0.901998,1.000999,1.138001  ) ;
			case 96: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.065999,-0.043999,-0.005000 ,  0.000000,90.000000,0.000000 ,  1.039999,1.176999,1.394001  ) ;
			case 97: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.043999,-0.005000 ,  0.000000,90.000000,0.000000 ,  1.039999,1.176999,1.394001  ) ;
			case 98: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.043999,-0.005000 ,  0.000000,90.000000,0.000000 ,  1.100999,1.176999,1.394001  ) ;
			case 100: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.043999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.100999,1.176999,1.394001  ) ;
			case 101: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.031999,-0.043999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.100999,1.176999,1.394001  ) ;
			case 102: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.043999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.100999,1.176999,1.394001  ) ;
			case 104: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.034999,-0.000000 ,  0.000000,90.000000,0.000000 ,  1.177999,1.176999,1.394001  ) ;
			case 106: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.044999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.198999,1.176999,1.394001  ) ;
			case 107: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.044999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.198999,1.176999,1.394001  ) ;
			case 108: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.044999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.026999,1.176999,1.394001  ) ;
			case 109: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.044999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.331999,1.394001  ) ;
			case 110: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.020999,-0.044999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.331999,1.394001  ) ;
			case 111: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.026999,-0.044999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.331999,1.394001  ) ;
			case 112: SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.018000,-0.066999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.331999,1.394001  ) ;
			case 114: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.066999,-0.007000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.331999,1.394001  ) ;
			case 115: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.066999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.331999,1.394001  ) ;
			case 116: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.066999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.144999,1.436999,1.394001  ) ;
			case 119: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.066999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.100999,1.224999,1.394001  ) ;
			case 120: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.100999,1.224999,1.394001  ) ;
			case 121: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.100999,1.224999,1.394001  ) ;
			case 122: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.948999,1.224999,1.394001  ) ;
			case 123: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.054999,1.256999,1.394001  ) ;
			case 124: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.054999,1.265999,1.394001  ) ;
			case 125: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.054999,1.265999,1.394001  ) ;
			case 126: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.054999,1.265999,1.394001  ) ;
			case 127: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,0.001999 ,  0.000000,90.000000,0.000000 ,  1.123998,1.363999,1.394001  ) ;
			case 134: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,0.001999 ,  0.000000,90.000000,0.000000 ,  0.980999,1.067999,1.082000  ) ;
			case 135: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.067999,1.432999,1.372001  ) ;
			case 136: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.016999,-0.046999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.939999,0.939999,1.126001  ) ;
			case 137: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.046999,-0.007000 ,  0.000000,90.000000,0.000000 ,  0.869999,0.939999,1.126001  ) ;
			case 147: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.046999,-0.000000 ,  0.000000,90.000000,0.000000 ,  1.044999,1.166999,1.199001  ) ;
			case 153: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.046999,-0.000000 ,  0.000000,90.000000,0.000000 ,  1.044999,1.166999,1.199001  ) ;
			case 154: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.046999,-0.000000 ,  0.000000,90.000000,0.000000 ,  1.044999,1.166999,1.199001  ) ;
			case 155: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.066999,-0.011000 ,  0.000000,90.000000,0.000000 ,  1.154999,1.391999,1.199001  ) ;
			case 156: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.066999,-0.011000 ,  0.000000,90.000000,0.000000 ,  1.080999,1.245999,1.199001  ) ;
			case 160: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.066999,-0.011000 ,  0.000000,90.000000,0.000000 ,  0.870999,1.104999,1.199001  ) ;
			case 161: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.066999,-0.011000 ,  0.000000,90.000000,0.000000 ,  0.979999,1.306999,1.199001  ) ;
			case 163: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.080999,-0.066999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.487999,1.199001  ) ;
			case 164: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.080999,-0.066999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.487999,1.199001  ) ;
			case 165: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.001999,-0.066999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.190999,1.199001  ) ;
			case 166: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.001999,-0.066999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.190999,1.199001  ) ;
			case 170: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.040999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.190999,1.199001  ) ;
			case 171: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.040999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.088999,1.270001  ) ;
			case 173: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.046999,-0.040999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 174: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.046999,-0.040999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 175: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.046999,-0.040999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 179: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.046999,-0.040999,-0.013000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 181: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.068999,-0.047999,-0.013000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 182: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.053999,-0.047999,-0.013000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 183: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.053999,-0.047999,-0.013000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 184: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.053999,-0.047999,-0.013000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 185: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.044999,-0.047999,-0.013000 ,  0.000000,90.000000,0.000000 ,  1.049999,1.239999,1.270001  ) ;
			case 186: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.030999,-0.047999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.104999,1.239999,1.270001  ) ;
			case 187: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.030999,-0.047999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.104999,1.239999,1.270001  ) ;
			case 188: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.030999,-0.047999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 189: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.030999,-0.047999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 191: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.072999,-0.047999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 192: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.072999,-0.047999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 193: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.072999,-0.050999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 194: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.072999,-0.050999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 195: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.072999,-0.043999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 200: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.049999,-0.069999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 202: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.049999,-0.069999,-0.009000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 206: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.049999,-0.059999,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 208: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.039999,-0.059999,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 210: SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.006000,-0.059999,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.985999,1.239999,1.270001  ) ;
			case 211: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.058999,-0.059999,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.892999,1.239999,1.270001  ) ;
			case 212: SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.016000,-0.059999,-0.001000 ,  0.000000,90.000000,0.000000 ,  0.892999,1.239999,1.270001  ) ;
			case 213: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.041999,-0.040999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.077999,1.239999,1.270001  ) ;
			case 217: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.041999,-0.040999,-0.010000 ,  0.000000,90.000000,0.000000 ,  0.950999,1.239999,1.270001  ) ;
			case 220: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.041999,-0.021999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.054999,1.239999,1.270001  ) ;
			case 221: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.034999,-0.043999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.095999,1.239999,1.270001  ) ;
			case 222: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.034999,-0.043999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.095999,1.239999,1.270001  ) ;
			case 223: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.017999,-0.043999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.095999,1.239999,1.270001  ) ;
			case 227: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.078999,-0.080999,-0.010000 ,  0.000000,90.000000,0.000000 ,  1.095999,1.239999,1.270001  ) ;
			case 228: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.027999,-0.042999,-0.011000 ,  0.000000,90.000000,0.000000 ,  1.095999,1.239999,1.270001  ) ;
			case 229: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.027999,-0.042999,-0.011000 ,  0.000000,90.000000,0.000000 ,  0.895999,1.019999,1.270001  ) ;
			case 230: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.027999,-0.042999,-0.011000 ,  0.000000,90.000000,0.000000 ,  0.895999,1.019999,1.270001  ) ;
			case 234: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.010999,-0.042999,-0.011000 ,  0.000000,90.000000,0.000000 ,  0.895999,1.019999,1.270001  ) ;
			case 235: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.010999,-0.042999,-0.011000 ,  0.000000,90.000000,0.000000 ,  0.895999,1.019999,1.270001  ) ;
			case 236: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.010999,-0.042999,-0.011000 ,  0.000000,90.000000,0.000000 ,  0.895999,1.019999,1.270001  ) ;
			case 239: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.072999,-0.057999,-0.011000 ,  0.000000,90.000000,0.000000 ,  1.039998,1.337998,1.324001  ) ;
			case 240: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.033999,-0.057999,-0.004000 ,  0.000000,90.000000,0.000000 ,  0.982998,1.153998,1.324001  ) ;
			case 247: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.033999,-0.057999,-0.018000 ,  0.000000,90.000000,0.000000 ,  1.090999,1.460998,1.324001  ) ;
			case 248: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.033999,-0.077999,-0.018000 ,  0.000000,90.000000,0.000000 ,  1.090999,1.460998,1.324001  ) ;
			case 250: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.033999,-0.077999,-0.018000 ,  0.000000,90.000000,0.000000 ,  1.090999,1.460998,1.324001  ) ;
			case 252: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.049999,-0.068999,0.003999 ,  0.000000,90.000000,0.000000 ,  1.009999,1.295998,1.324001  ) ;
			case 254: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.049999,-0.030999,-0.013000 ,  0.000000,90.000000,0.000000 ,  1.097998,1.295998,1.324001  ) ;
			case 255: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.049999,-0.030999,-0.004000 ,  0.000000,90.000000,0.000000 ,  1.045999,1.053998,1.249001  ) ;
			case 258: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.052999,-0.005999,-0.009000 ,  0.000000,90.000000,0.000000 ,  1.239999,1.130998,1.372001  ) ;
			case 259: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.042999,-0.012999,-0.014000 ,  0.000000,90.000000,0.000000 ,  1.239999,1.130998,1.372001  ) ;
			case 261: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.029999,-0.038999,-0.010000 ,  0.000000,90.000000,0.000000 ,  0.867999,0.918998,1.073001  ) ;
			case 265: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.040999,-0.015999,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.082999,1.042998,1.238001  ) ;
			case 266: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.040999,-0.051999,-0.008000 ,  0.000000,90.000000,0.000000 ,  1.082999,1.113998,1.238001  ) ;
			case 267: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.245999,-0.034999,-0.011000 ,  0.000000,90.000000,0.000000 ,  1.082999,1.113998,1.238001  ) ;
			case 270: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.082999,1.113998,1.238001  ) ;
			case 271: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.048999,-0.048999,-0.006000 ,  0.000000,90.000000,0.000000 ,  1.082999,1.113998,1.238001  ) ;
			case 272: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.036999,-0.011999,-0.017000 ,  0.000000,90.000000,0.000000 ,  1.216999,1.113998,1.238001  ) ;
			case 273: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.036999,-0.009999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.026999,0.996998,1.238001  ) ;
			case 274: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 275: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 276: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 280: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 281: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 282: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 283: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.062999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 284: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.037999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 285: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.073999,-0.034999,-0.009999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 286: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.036999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.096999,0.996998,1.238001  ) ;
			case 287: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.036999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.082999,0.974998,1.238001  ) ;
			case 288: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.064999,-0.036999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.082999,0.974998,1.238001  ) ;
			case 289: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.037999,-0.036999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.128999,1.172998,1.238001  ) ;
			case 290: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.048999,-0.051999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.128999,1.172998,1.238001  ) ;
			case 291: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.048999,-0.057999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.128999,1.172998,1.238001  ) ;
			case 292: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.089999,-0.057999,-0.006999 ,  0.000000,90.000000,0.000000 ,  0.964999,1.172998,1.238001  ) ;
			case 293: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.089999,-0.057999,-0.006999 ,  0.000000,90.000000,0.000000 ,  0.964999,1.172998,1.238001  ) ;
			case 294: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.079999,-0.057999,-0.006999 ,  0.000000,90.000000,0.000000 ,  0.964999,1.172998,1.238001  ) ;
			case 295: SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.009000,-0.054999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.038999,1.172998,1.238001  ) ;
			case 296: SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.009000,-0.054999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 297: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.048999,-0.054999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 299: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.074999,-0.054999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 300: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 301: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 302: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 303: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 304: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 305: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.085999,1.220998,1.238001  ) ;
			case 306: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  0.881999,1.220998,1.238001  ) ;
			case 307: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  0.881999,1.220998,1.238001  ) ;
			case 308: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  0.881999,1.220998,1.238001  ) ;
			case 309: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  0.881999,1.220998,1.238001  ) ;
			case 310: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.076999,1.220998,1.238001  ) ;
			case 311: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059999,-0.062999,-0.006999 ,  0.000000,90.000000,0.000000 ,  1.076999,1.220998,1.238001  ) ;
			default: SetPlayerAttachedObject ( playerid, 6, setobject, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000  ) ;
		}
	}
	else if(type == 19)//ђип °л§пы 1
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.029000,-0.003001, 0.000000,90.000000,91.799987, 1.000000,1.000000,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.029000,-0.003001, 0.000000,90.000000,91.799987, 1.000000,1.000000,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.024000,-0.001001, 0.000000,90.000000,91.799987, 1.000000,1.093999,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157998,0.024000,-0.001001, 0.000000,90.000000,91.799987, 1.000000,1.093999,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138997,0.032999,-0.006001, 0.000000,90.000000,91.799987, 1.000000,1.093999,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116997,0.028999,0.002999, 0.000000,90.000000,91.799987, 1.000000,1.093999,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111997,0.024999,0.002999, 0.000000,90.000000,91.799987, 1.000000,1.093999,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.024999,0.002999, 0.000000,90.000000,91.799987, 1.000000,1.093999,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.013999,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.045000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.005000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.027000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.087998,0.027000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128998,0.027000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.027000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107998,0.034000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,0.044000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.039000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104998,0.039000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109997,0.024000,0.002998, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.074997,0.032000,0.002998, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098997,0.050000,0.002998, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098997,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.045000,-0.000001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117997,0.045000,-0.003001, 0.000000,90.000000,91.799987, 1.040000,1.093999,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130997,0.020999,-0.006001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.054999,-0.006001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.029000,-0.006001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107997,0.022000,-0.006001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.052999,-0.002001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092998,0.037000,-0.002001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128997,0.043000,-0.002001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128997,0.043000,-0.002001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.043000,-0.002001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.043000,-0.002001, 0.000000,90.000000,91.799987, 1.080000,1.142999,1.000000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.043000,-0.002001, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.025000,-0.002001, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.039999,0.001999, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.039999,0.001999, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118997,0.039999,0.001999, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.014000,0.001999, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 80: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,0.024000,0.001999, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 81: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098998,0.024000,0.001999, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155998,0.047000,0.001999, 0.000000,90.000000,91.799987, 0.934000,1.142999,1.000000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,0.037000,0.001999, 0.000000,90.000000,91.799987, 1.101000,1.142999,1.000000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134997,0.037000,0.001999, 0.000000,90.000000,91.799987, 1.101000,1.142999,1.000000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.012000,0.001999, 0.000000,90.000000,91.799987, 0.891000,0.925999,1.000000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.031000,0.001999, 0.000000,90.000000,91.799987, 0.955000,0.974999,1.000000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.020000,0.001999, 0.000000,90.000000,91.799987, 0.955000,0.974999,1.000000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.020000,0.001999, 0.000000,90.000000,91.799987, 0.955000,0.974999,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120998,0.010000,0.001999, 0.000000,90.000000,91.799987, 0.955000,0.974999,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.032000,-0.003001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.032000,-0.003001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.045000,-0.003001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138998,0.029000,-0.000001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.158998,0.031000,-0.000001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.031000,-0.000001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,0.031000,-0.000001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.166998,0.028000,-0.000001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.160998,0.021000,-0.000001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.032000,-0.000001, 0.000000,90.000000,91.799987, 0.955000,1.033999,1.000000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.036000,-0.000001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124998,0.019000,-0.001001, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.027000,0.000998, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.027000,0.000998, 0.000000,90.000000,91.799987, 1.021000,1.055000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.027000,-0.006001, 0.000000,90.000000,91.799987, 1.137000,1.146999,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.040000,-0.006001, 0.000000,90.000000,91.799987, 1.137000,1.146999,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.040000,-0.006001, 0.000000,90.000000,91.799987, 0.972000,1.046999,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.026000,0.003998, 0.000000,90.000000,91.799987, 0.972000,1.046999,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.026000,0.003998, 0.000000,90.000000,91.799987, 0.972000,1.046999,1.000000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.168998,0.048999,0.003998, 0.000000,90.000000,91.799987, 0.972000,1.046999,1.000000 ) ;
			case 131: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095998,0.035000,0.003998, 0.000000,90.000000,91.799987, 0.972000,1.046999,1.000000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.038998,0.023000,-0.001001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.023000,0.005998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123998,0.019000,0.001998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,0.018000,0.001998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.028000,0.001998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.173998,0.014000,0.001998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.032000,0.001998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.032000,0.001998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.035000,0.001998, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.035000,-0.006001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.035000,-0.006001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.035000,-0.006001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126998,0.035000,-0.006001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.014999,-0.001001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.026000,-0.001001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.019999,-0.001001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.019999,-0.001001, -1.599999,90.000000,91.399993, 0.972000,1.046999,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135998,0.026000,-0.005001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.164998,0.033999,-0.005001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.033999,-0.005001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134998,0.022999,-0.005001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.038999,-0.005001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.038999,-0.005001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118998,0.038999,-0.008001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.029999,-0.001001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.021999,0.002998, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.016999,0.002998, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111998,0.032999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.025999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.024999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.024999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.024999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.024999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153998,0.035999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127998,0.039999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.026999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.037999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133998,0.037999,-0.000001, -1.599999,90.000000,91.399993, 1.019000,1.083999,1.000000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,0.020999,0.001998, -1.599999,90.000000,91.399993, 1.019000,1.166999,1.000000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145998,0.013999,0.001998, -1.599999,90.000000,91.399993, 1.019000,1.166999,1.000000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.168998,0.039999,0.001998, -1.599999,90.000000,91.399993, 1.019000,1.166999,1.000000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.014999,0.001998, -1.599999,90.000000,91.399993, 1.019000,1.166999,1.000000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129998,0.044999,0.001998, -1.599999,90.000000,91.399993, 1.019000,1.166999,1.000000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152998,0.035999,-0.001001, -1.599999,90.000000,91.399993, 1.019000,1.166999,1.000000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108998,0.022999,-0.001001, -1.599999,90.000000,91.399993, 1.019000,1.166999,1.000000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108998,0.014999,-0.001001, -1.599999,90.000000,91.399993, 1.019000,1.001999,1.000000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.077998,0.014999,-0.001001, -1.599999,90.000000,91.399993, 1.019000,1.001999,1.000000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100998,0.027999,-0.001001, -1.599999,90.000000,91.399993, 1.019000,1.001999,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144998,0.037999,0.000998, -1.599999,90.000000,91.399993, 1.019000,1.001999,1.000000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139998,0.029000,-0.001001, -1.599999,90.000000,91.399993, 1.019000,1.001999,1.000000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.163998,0.036000,-0.002001, -1.599999,90.000000,91.399993, 1.046000,1.094000,1.000000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119998,0.036000,-0.002001, -1.599999,90.000000,91.399993, 1.046000,1.094000,1.000000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.028000,-0.002001, -1.599999,90.000000,91.399993, 1.046000,1.094000,1.000000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.028000,-0.002001, -1.599999,90.000000,91.399993, 1.046000,1.094000,1.000000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.028000,0.001998, -1.599999,90.000000,91.399993, 1.046000,1.094000,1.000000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130998,0.025000,0.001998, -1.599999,90.000000,91.399993, 1.046000,1.094000,1.000000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096998,0.041999,0.001998, -1.599999,90.000000,91.399993, 1.046000,1.094000,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096998,0.031000,-0.000001, -1.599999,90.000000,91.399993, 0.957000,1.094000,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.031000,-0.000001, -1.599999,90.000000,91.399993, 0.957000,1.094000,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109998,0.031000,-0.000001, -1.599999,90.000000,91.399993, 0.957000,1.094000,1.000000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.037999,-0.002001, -1.599999,90.000000,91.399993, 0.957000,1.137000,1.000000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117998,0.020999,-0.002001, -1.599999,90.000000,91.399993, 0.957000,1.137000,1.000000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,0.031999,-0.002001, -1.599999,90.000000,91.399993, 0.957000,1.137000,1.000000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,0.031999,-0.002001, -1.599999,90.000000,91.399993, 0.977999,1.008000,1.000000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105998,0.031999,-0.002001, -1.599999,90.000000,91.399993, 0.977999,1.008000,1.000000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.035999,-0.002001, -1.599999,90.000000,91.399993, 0.977999,1.008000,1.000000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.035999,-0.002001, -1.599999,90.000000,91.399993, 0.977999,1.008000,1.000000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.035999,-0.002001, -1.599999,90.000000,91.399993, 0.977999,1.008000,1.000000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110998,0.035999,-0.002001, -1.599999,90.000000,91.399993, 0.977999,1.008000,1.000000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122998,0.031999,0.001998, -1.599999,90.000000,91.399993, 0.977999,1.104000,1.000000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161998,0.040999,0.001998, -1.599999,90.000000,91.399993, 0.977999,1.104000,1.000000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116998,0.030999,0.001998, -1.599999,90.000000,91.399993, 0.977999,1.104000,1.000000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140998,0.035999,-0.006001, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.027999,-0.002001, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125998,0.005999,-0.002001, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.028999,0.002998, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136998,0.028999,0.002998, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.035999,0.002998, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.035999,0.002998, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.035999,0.002998, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.035999,0.002998, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.035999,0.002998, -1.599999,90.000000,91.399993, 1.037000,1.104000,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.035999,0.002998, -1.599999,90.000000,91.399993, 0.898000,0.969000,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.027999,-0.000001, -1.599999,90.000000,91.399993, 0.898000,1.016000,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.106998,0.027999,-0.000001, -1.599999,90.000000,91.399993, 0.898000,1.016000,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150999,-0.004999,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
		}
	}
	else if(type == 20)//ђип °л§пы 2
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101999,0.004999,0.000000, 0.499999,87.200019,91.700004, 1.072000,1.068000,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119999,0.010999,0.002000, 0.499999,87.200019,91.700004, 1.163999,1.109000,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148000,0.001999,0.002000, 0.499999,87.200019,91.700004, 1.163999,1.109000,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134999,-0.001000,-0.003000, 0.499999,87.200019,91.700004, 1.163999,1.130000,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115999,0.021999,-0.003000, 0.499999,87.200019,91.700004, 1.163999,1.130000,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.085999,0.000999,-0.003000, 0.499999,87.200019,91.700004, 1.163999,1.130000,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100999,0.003999,-0.003000, 0.499999,87.200019,91.700004, 1.039999,1.032000,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107999,0.009999,-0.003000, 0.499999,87.200019,91.700004, 1.039999,1.032000,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120999,-0.003000,-0.003000, 0.499999,87.200019,91.700004, 1.039999,1.032000,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137999,0.010999,0.000000, 0.499999,87.200019,91.700004, 1.039999,1.097000,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097999,-0.018000,0.000000, 0.499999,87.200019,91.700004, 1.039999,1.097000,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115999,0.003999,0.000000, -78.300010,113.100013,-13.799970, 1.039999,1.097000,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109999,-0.003000,-0.003999, -78.300010,113.100013,-13.799970, 1.039999,1.097000,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109999,-0.003000,0.000000, -78.300010,113.100013,-13.799970, 1.114999,1.097000,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109999,-0.003000,0.000000, -78.300010,113.100013,-13.799970, 1.114999,1.097000,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094999,0.014999,0.004000, -78.300010,113.100013,-13.799970, 1.114999,1.097000,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,0.012999,0.002000, -78.300010,103.000015,-13.799970, 1.233999,1.090000,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,0.011999,-0.006999, -78.300010,103.000015,-13.799970, 1.190000,1.202000,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,-0.001000,-0.003999, -78.300010,103.000015,-13.799970, 1.190000,1.202000,1.000000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.031000,0.006999,-0.003999, -78.300010,103.000015,-13.799970, 1.063999,1.144000,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.080000,0.024999,0.002000, -78.300010,103.000015,-13.799970, 1.013999,1.013000,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094000,-0.002000,0.000000, -78.300010,103.000015,-13.799970, 1.013999,1.013000,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,0.017999,-0.002999, -78.300010,103.000015,-13.799970, 1.110000,1.071000,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,0.009999,-0.002999, -78.300010,103.000015,-13.799970, 1.170000,1.099000,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,-0.014000,-0.004999, -78.300010,103.000015,-13.799970, 1.170000,1.099000,1.000000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,0.022999,0.002000, -78.300010,103.000015,-13.799970, 1.170000,1.099000,1.000000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,-0.007000,0.002000, -78.300010,103.000015,-13.799970, 1.170000,1.099000,1.000000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,-0.012000,0.007000, -78.300010,103.000015,-13.799970, 1.341000,1.138000,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,0.011999,0.001000, -78.300010,103.000015,-13.799970, 1.243999,1.178000,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088000,-0.000000,0.001000, -78.300010,103.000015,-13.799970, 1.009999,0.943000,0.814999 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107000,0.002999,-0.007999, -78.300010,108.500007,-13.799970, 1.091999,1.096000,0.814999 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111999,0.013000,0.000000, 83.900001,67.399971,0.000000, 1.036000,1.000000,1.000000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111999,0.013000,0.000000, 83.900001,67.399971,0.000000, 1.036000,1.000000,1.000000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111999,0.013000,0.000000, 83.900001,67.399971,0.000000, 1.036000,1.000000,1.000000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122999,-0.011000,0.000000, 83.900001,67.399971,0.000000, 1.036000,1.000000,1.000000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122999,0.008999,0.006000, 83.900001,67.399971,0.000000, 1.036000,1.000000,1.000000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108999,0.013999,0.001000, 83.900001,67.399971,0.000000, 1.036000,1.000000,1.000000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118999,0.013999,0.001000, 83.900001,67.399971,0.000000, 1.036000,1.000000,1.000000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118999,-0.012000,-0.002999, 83.900001,67.399971,0.000000, 1.137000,1.054999,1.000000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097999,0.030000,-0.002999, 83.900001,67.399971,0.000000, 1.250000,1.192000,1.000000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097999,0.011999,-0.002999, 83.900001,67.399971,0.000000, 1.263000,1.166000,1.000000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097999,0.011999,-0.002999, 83.900001,67.399971,0.000000, 1.263000,1.166000,1.000000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.080999,-0.014000,0.002000, 83.900001,67.399971,0.000000, 1.164000,1.059000,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.080999,-0.014000,0.002000, 83.900001,67.399971,0.000000, 1.164000,1.059000,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108999,0.006999,0.002000, 83.900001,67.399971,0.000000, 1.164000,1.059000,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.108999,-0.004000,0.002000, 83.900001,67.399971,0.000000, 1.164000,1.059000,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116999,0.019999,0.002000, 83.900001,81.599967,0.000000, 1.164000,1.059000,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116999,-0.001000,0.004000, 83.900001,81.599967,0.000000, 1.164000,1.101000,1.000000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129999,0.005999,0.004000, 83.900001,81.599967,0.000000, 1.164000,1.101000,1.000000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129999,0.005999,0.004000, 83.900001,81.599967,0.000000, 1.164000,1.101000,1.000000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151000,-0.003000,0.004000, 83.900001,81.599967,0.000000, 1.164000,1.101000,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,-0.004000,-0.001999, 83.900001,81.599967,0.000000, 1.285000,1.145000,1.000000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104000,0.009999,-0.001999, 83.900001,81.599967,0.000000, 1.069000,1.012000,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104000,0.009999,-0.001999, 83.900001,81.599967,0.000000, 1.069000,1.012000,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143000,0.005999,0.001000, 83.900001,81.599967,0.000000, 1.069000,1.096000,1.000000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143000,-0.000000,0.001000, 83.900001,67.899978,0.000000, 1.069000,1.096000,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084000,0.021999,0.001000, 83.900001,67.899978,0.000000, 1.069000,1.096000,1.000000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084000,0.021999,0.001000, 83.900001,67.899978,0.000000, 1.069000,1.096000,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109000,0.007999,-0.003999, 83.900001,67.899978,0.000000, 1.088001,1.096000,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,-0.017000,0.001000, 83.900001,67.899978,0.000000, 1.088001,1.096000,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121000,-0.007000,0.001000, 83.900001,67.899978,0.000000, 1.088001,1.096000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121000,-0.005000,-0.001999, 83.900001,67.899978,0.000000, 1.201001,1.245000,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121000,-0.005000,-0.001999, 83.900001,67.899978,0.000000, 1.201001,1.245000,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095000,0.011999,-0.001999, 83.900001,67.899978,0.000000, 1.038001,1.037000,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,-0.007000,0.006000, 83.900001,67.899978,0.000000, 1.151000,1.146000,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,-0.001000,0.006000, 83.900001,67.899978,0.000000, 1.151000,1.146000,1.000000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.024000,0.000999,0.001000, 83.900001,67.899978,0.000000, 0.996000,0.988000,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094000,-0.015000,0.010000, 83.900001,67.899978,0.000000, 1.064000,1.090000,1.000000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.094000,-0.015000,0.004000, 83.900001,67.899978,0.000000, 1.260000,1.090000,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,-0.015000,0.004000, 83.900001,67.899978,0.000000, 1.260000,1.090000,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.073000,-0.002000,0.004000, 83.900001,67.899978,3.199999, 1.154000,1.075000,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146000,-0.024000,0.004000, 83.900001,67.899978,3.199999, 1.154000,1.202000,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.080000,0.016999,0.004000, 83.900001,67.899978,3.199999, 1.024000,1.102000,1.000000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.003999,0.004000, 83.900001,67.899978,3.199999, 1.024000,1.102000,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.003999,0.004000, 83.900001,67.899978,3.199999, 1.024000,1.102000,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.003999,0.002000, 83.900001,67.899978,3.199999, 1.024000,1.102000,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.003999,0.002000, 83.900001,67.899978,3.199999, 1.111000,1.102000,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.003999,0.002000, 83.900001,67.899978,3.199999, 1.111000,1.102000,1.000000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114000,-0.027000,0.002000, 83.900001,67.899978,3.199999, 1.180000,1.102000,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114000,0.002999,-0.002999, 83.900001,67.899978,3.199999, 1.108000,1.106000,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123000,-0.008000,0.001000, 83.900001,67.899978,3.199999, 1.195000,1.106000,1.000000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.099000,-0.002000,0.001000, 83.900001,67.899978,3.199999, 1.195000,1.106000,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.099000,-0.002000,-0.006999, 83.900001,67.899978,3.199999, 1.195000,1.106000,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,0.002999,-0.006999, 83.900001,67.899978,3.199999, 1.113000,1.106000,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145000,-0.017000,-0.002999, 83.900001,67.899978,3.199999, 1.113000,1.106000,1.000000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098000,0.008999,-0.002999, 83.900001,67.899978,3.199999, 1.113000,1.106000,1.000000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098000,0.008999,-0.002999, 83.900001,67.899978,3.199999, 1.113000,1.106000,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098000,0.008999,-0.002999, 83.900001,67.899978,3.199999, 1.113000,1.106000,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.121000,-0.002000,0.005000, 83.900001,67.899978,3.199999, 1.188000,1.129000,1.000000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097000,-0.002000,-0.001999, 83.900001,67.899978,3.199999, 1.188000,1.129000,1.000000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097000,-0.002000,0.005000, 83.900001,67.899978,3.199999, 1.188000,1.129000,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097000,-0.002000,0.005000, 83.900001,67.899978,3.199999, 1.188000,1.129000,1.000000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097000,0.001999,0.001000, 83.900001,67.899978,3.199999, 1.188000,1.157000,1.000000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135000,-0.009000,0.001000, 83.900001,67.899978,3.199999, 1.188000,1.157000,1.000000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135000,-0.009000,0.001000, 83.900001,67.899978,3.199999, 1.188000,1.157000,1.000000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135000,-0.009000,0.001000, 83.900001,67.899978,3.199999, 1.188000,1.157000,1.000000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135000,-0.009000,0.001000, 83.900001,67.899978,3.199999, 1.188000,1.157000,1.000000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,-0.005000,0.001000, 83.900001,67.899978,3.199999, 1.188000,1.070000,1.000000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111000,0.001999,0.001000, 83.900001,67.899978,3.199999, 1.188000,1.070000,1.000000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111000,0.021999,0.001000, 83.900001,67.899978,3.199999, 1.000000,1.070000,1.000000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093000,0.004999,0.001000, 83.900001,67.899978,3.199999, 1.000000,1.070000,1.000000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114000,0.012999,0.001000, 83.900001,67.899978,3.199999, 1.000000,1.070000,1.000000 ) ;
			case 209: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088000,0.008999,0.001000, 83.900001,67.899978,3.199999, 1.000000,1.070000,1.000000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.088000,-0.008000,0.001000, 83.900001,67.899978,3.199999, 1.000000,1.070000,1.000000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133000,-0.003000,0.001000, 83.900001,67.899978,3.199999, 1.000000,1.138000,1.000000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124000,0.002999,0.001000, 83.900001,67.899978,3.199999, 1.120000,1.138000,1.000000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143000,-0.020000,0.005000, 83.900001,67.899978,3.199999, 1.120000,1.238000,1.000000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107000,-0.015000,0.005000, 83.900001,67.899978,3.199999, 1.293000,1.238000,1.000000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125000,0.006999,0.005000, 83.900001,67.899978,3.199999, 1.329000,1.055001,1.000000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.090000,-0.015000,-0.001999, 83.900001,67.899978,3.199999, 1.232000,1.192001,1.000000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.016999,-0.001999, 83.900001,67.899978,3.199999, 1.140000,1.131000,1.000000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122000,0.005999,-0.001999, 83.900001,67.899978,3.199999, 1.206000,1.205001,1.000000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,-0.009000,-0.001999, 83.900001,67.899978,3.199999, 1.115000,1.071000,1.000000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,-0.021000,0.002000, 83.900001,67.899978,3.199999, 1.021000,0.924000,1.000000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.069000,-0.009000,-0.001999, 83.900001,67.899978,3.199999, 1.021000,0.924000,1.000000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097000,-0.002000,0.003000, 83.900001,67.899978,3.199999, 1.092000,1.010000,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,-0.007000,0.003000, 83.900001,67.899978,3.199999, 1.136000,1.116000,1.000000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097000,0.001999,-0.001999, 83.900001,67.899978,3.199999, 1.136000,1.116000,1.000000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,-0.009000,0.004000, 83.900001,67.899978,3.199999, 1.169000,1.116000,1.000000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,-0.002000,0.004000, 83.900001,67.899978,3.199999, 1.169000,1.116000,1.000000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131000,-0.002000,0.004000, 83.900001,67.899978,3.199999, 1.169000,1.116000,1.000000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.131000,-0.014000,0.004000, 83.900001,67.899978,3.199999, 1.169000,1.116000,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086000,0.010999,-0.002999, 83.900001,67.899978,3.199999, 1.029000,1.033000,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107000,-0.004000,-0.002999, 83.900001,67.899978,3.199999, 1.029000,1.033000,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107000,-0.008000,-0.002999, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107000,-0.008000,-0.002999, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135000,-0.002000,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095000,-0.002000,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,0.000999,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,0.000999,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,0.008999,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101000,0.011999,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101000,0.006999,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101000,0.014999,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101000,0.007999,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.157000,-0.001000,0.002000, 83.900001,67.899978,3.199999, 1.078999,1.103000,1.000000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.085000,0.005999,-0.003999, 83.900001,67.899978,3.199999, 1.078999,0.962000,1.000000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144000,0.002999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100000,-0.002000,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,-0.023000,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152000,-0.016000,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.006999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.006999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.006999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.006999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.006999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.006999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.002999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.002999,0.001000, 83.900001,67.899978,3.199999, 1.107999,1.071000,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150999,-0.004999,0.001999, 0.000000,0.600003,-6.399982, 1.051999,0.849999,0.970000 ) ;
		}
	}
	else if(type == 21)//љанданы на голову
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120000,-0.001000,0.000000, -92.499984,-7.199993,-98.099990, 1.114999,1.000000,0.901000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120000,0.006999,0.007000, -92.499984,-7.199993,-98.099990, 1.188999,1.256000,1.157000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141999,-0.000000,0.001999, -92.499984,-7.199993,-98.099990, 1.175999,1.256000,1.083999 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141999,-0.000000,0.001999, -92.499984,-7.199993,-98.099990, 1.175999,1.256000,1.083999 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.123000,0.017000,0.001999, -84.299972,-5.799993,-98.099990, 1.216999,1.256000,1.011999 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.091000,0.003000,0.001999, -84.299972,-5.799993,-98.099990, 1.237999,1.256000,1.057999 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104000,0.013000,0.006000, -91.399986,-5.799993,-92.200004, 1.262999,1.256000,1.122999 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.071000,-0.015999,-0.000000, -91.399986,-5.799993,-92.200004, 1.181999,1.256000,0.974999 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100000,0.009000,-0.000000, -91.399986,-5.799993,-92.200004, 1.262999,1.256000,0.974999 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.085999,0.003000,-0.000000, -91.399986,-5.799993,-92.200004, 0.994999,1.256000,1.021000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116999,0.003000,-0.000000, -91.399986,-5.799993,-92.200004, 1.037999,1.256000,1.094000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116999,0.003000,-0.000000, -91.399986,-5.799993,-92.200004, 1.132999,1.256000,1.094000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116999,0.003000,0.004000, -91.399986,-5.799993,-92.200004, 1.157999,1.056999,0.877000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116999,0.003000,0.004000, -91.399986,-5.799993,-92.200004, 1.005999,1.056999,1.086000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116999,0.003000,-0.002000, -91.399986,-5.799993,-92.200004, 1.277999,1.056999,1.107000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097999,0.016000,-0.000000, -91.399986,-5.799993,-92.200004, 1.022999,1.056999,0.863000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097999,-0.002999,-0.000000, -91.399986,-5.799993,-92.200004, 1.022999,1.056999,1.034000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120999,0.020000,-0.000000, -91.399986,-5.799993,-92.200004, 1.135999,1.056999,1.154000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120999,0.011000,-0.000000, -91.399986,-5.799993,-92.200004, 1.135999,1.056999,1.154000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130999,-0.004999,-0.000000, -91.399986,-5.799993,-92.200004, 1.189999,1.056999,1.195000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130999,0.024000,-0.000000, -91.399986,-5.799993,-92.200004, 1.189999,1.056999,1.195000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,0.002000,-0.000000, -91.399986,-5.799993,-92.200004, 1.002999,1.056999,0.939000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126999,0.006000,-0.000000, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,1.119000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107999,0.001000,-0.000000, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,0.950000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107999,0.001000,0.000999, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,0.950000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107999,0.027000,0.000999, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,0.950000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107999,-0.017999,0.003999, -91.399986,-5.799993,-92.200004, 1.160999,1.301999,0.950000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107999,0.012000,0.004999, -91.399986,-5.799993,-92.200004, 1.160999,1.301999,0.950000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.107999,-0.019999,0.004999, -91.399986,-5.799993,-92.200004, 1.160999,1.301999,1.005000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096000,-0.010999,0.000999, -91.399986,-5.799993,-92.200004, 1.084999,1.358999,0.969000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096000,-0.010999,0.007000, -91.399986,-5.799993,-92.200004, 1.206999,1.358999,1.074000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096000,-0.010999,-0.000000, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,0.977000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114000,0.004000,0.001999, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,0.977000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,-0.004999,0.001999, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,0.977000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.099000,0.021000,0.001999, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,1.086000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.007000,0.001999, -91.399986,-5.799993,-92.200004, 1.133999,1.358999,1.158000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.003000,0.001999, -91.399986,-5.799993,-92.200004, 1.133999,1.358999,1.158000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,-0.001999,-0.004000, -91.399986,-5.799993,-92.200004, 1.318998,1.358999,1.158000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.197998,1.126999,0.946000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.086000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.055998,1.126999,0.946000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.126999,1.101000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.080998,1.126999,0.975000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.080998,1.126999,0.975000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.167998,1.126999,0.975000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120000,-0.005999,0.001999, -91.399986,-5.799993,-92.200004, 1.167998,1.126999,1.113000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120000,0.000000,0.001999, -91.399986,-5.799993,-92.200004, 1.167998,1.126999,1.113000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120000,0.000000,-0.002000, -91.399986,-5.799993,-92.200004, 1.242998,1.126999,1.113000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120000,0.000000,-0.002000, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120000,0.008000,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,-0.009999,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.008000,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095000,-0.003999,0.006000, -91.399986,-5.799993,-92.200004, 1.119998,1.157999,1.061000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095000,-0.003999,0.006000, -91.399986,-5.799993,-92.200004, 1.181998,1.157999,1.135000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095000,-0.003999,0.006000, -91.399986,-5.799993,-92.200004, 1.449998,1.497999,1.211000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095000,-0.003999,0.001999, -91.399986,-5.799993,-92.200004, 1.075998,1.218000,1.063000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,-0.002999,0.001999, -91.399986,-5.799993,-92.200004, 1.325998,1.434000,1.209000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.084000,0.015000,0.001999, -91.399986,-5.799993,-92.200004, 1.171998,1.086000,0.945000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.007000,0.001999, -91.399986,-5.799993,-92.200004, 1.171998,1.086000,0.945000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.007000,0.001999, -91.399986,-5.799993,-92.200004, 1.000998,1.086000,0.897000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.002000,0.001999, -91.399986,-5.799993,-92.200004, 1.037998,1.086000,1.023000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.002000,0.001999, -91.399986,-5.799993,-92.200004, 1.037998,1.086000,1.023000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.010000,0.005000, -91.399986,-5.799993,-92.200004, 1.037998,1.086000,1.023000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.010000,-0.001999, -91.399986,-5.799993,-92.200004, 1.091998,1.086000,1.215000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,-0.007999,0.003000, -91.399986,-5.799993,-92.200004, 1.091998,1.086000,1.142000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,-0.007999,0.003000, -91.399986,-5.799993,-92.200004, 1.157998,1.086000,1.142000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,0.006000,0.003000, -91.399986,-5.799993,-92.200004, 1.157998,1.086000,1.142000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139000,-0.006000,0.000000, -91.399986,-5.799993,-92.200004, 1.157998,1.086000,1.142000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103000,0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.044998,1.086000,1.035000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103000,0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.044998,1.086000,1.035000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103000,0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.135000,-0.002999,0.000000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.124000,-0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103000,-0.010000,0.007000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103000,-0.001000,0.007000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125000,-0.008000,0.007000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125000,-0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.160998,1.306000,1.239000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125000,-0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.160998,1.306000,1.239000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125000,-0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.222998,1.306000,1.103000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.020999,0.001000, -91.399986,-5.799993,-92.200004, 1.038998,1.306000,0.880000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.087000,0.006999,-0.000999, -91.399986,-5.799993,-92.200004, 1.038998,1.306000,0.880000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.087000,-0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.038998,1.306000,0.880000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109000,-0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.180998,1.306000,0.950000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.006000,0.002000, -91.399986,-5.799993,-92.200004, 1.180998,1.306000,0.950000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,0.002000,0.002000, -91.399986,-5.799993,-92.200004, 1.301998,1.306000,1.174000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,-0.007999,0.002000, -91.399986,-5.799993,-92.200004, 1.301998,1.306000,1.204000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.017000,0.002000, -91.399986,-5.799993,-92.200004, 1.122998,1.306000,1.145000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.017000,0.002000, -91.399986,-5.799993,-92.200004, 1.122998,1.306000,1.145000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.004000,0.002000, -91.399986,-5.799993,-92.200004, 1.122998,1.306000,1.145000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.097000,-0.009999,0.002000, -91.399986,-5.799993,-92.200004, 1.200998,1.306000,1.009000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.116000,-0.020999,0.002000, -91.399986,-5.799993,-92.200004, 0.980998,1.115000,0.973000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.064000,-0.004999,0.002000, -91.399986,-5.799993,-92.200004, 1.021999,1.115000,0.973000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095000,-0.003999,0.002000, -91.399986,-5.799993,-92.200004, 1.051999,1.115000,1.028000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.010000,0.002000, -91.399986,-5.799993,-92.200004, 1.131999,1.115000,1.182000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.131999,1.115000,1.182000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.131999,1.115000,1.182000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.237999,1.115000,1.182000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104000,-0.002999,0.002000, -91.399986,-5.799993,-92.200004, 1.302999,1.267000,1.182000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.099999,1.267000,1.007000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.099999,1.267000,1.007000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.093000,0.002000,-0.000999, -91.399986,-5.799993,-92.200004, 1.200999,1.267000,0.945000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.100000,-0.008999,0.001000, -91.399986,-5.799993,-92.200004, 1.152999,1.267000,0.993000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122000,0.000000,0.001000, -91.399986,-5.799993,-92.200004, 1.152999,1.267000,0.993000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.081000,0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.152999,1.267000,0.993000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.092000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.016000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.102000,0.004000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110000,0.011000,0.001000, -91.399986,-5.799993,-92.200004, 1.058999,1.267000,0.956000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110000,0.005000,0.001000, -91.399986,-5.799993,-92.200004, 1.058999,1.267000,0.956000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110000,-0.002999,0.001000, -91.399986,-5.799993,-92.200004, 1.058999,1.267000,0.956000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110000,0.002000,0.001000, -91.399986,-5.799993,-92.200004, 1.177999,1.267000,1.027000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,-0.017999,0.001000, -91.399986,-5.799993,-92.200004, 1.177999,1.267000,1.027000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.046999,0.011999,-0.001999, -87.500000,16.199996,-95.200027, 0.962998,1.000000,0.949000 ) ;
		}
	}
	else if(type == 22)//Фсы
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.108000,0.003000, 0.000000,0.000000,-81.399993, 1.000000,1.000000,1.000000 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.117000,0.003000, 0.000000,0.000000,-60.399993, 1.000000,1.000000,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.130000,0.000999, 0.000000,0.000000,-60.399993, 1.000000,1.000000,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.076999,0.126000,-0.000000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.058000,0.125000,-0.002000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039000,0.112000,0.001999, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.026000,0.127000,-0.002000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.001999,0.105000,-0.001000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017000,0.119000,-0.001000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005000,0.109000,-0.001000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023000,0.114000,0.000999, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.021000,0.136000,0.000999, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.004000,0.097000,-0.002000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029000,0.110000,0.001999, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.002000,0.113000,0.001999, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025000,0.118000,-0.003000, 0.000000,0.000000,-91.300003, 1.000000,1.000000,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.026000,0.107000,-0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028000,0.130000,-0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034000,0.125000,-0.006000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025000,0.123000,-0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.108000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.104000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018999,0.118000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.022999,0.124000,-0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.125000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.130000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 31: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.129000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.016999,0.094000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.013999,0.101000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038000,0.119000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017999,0.117000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.009999,0.107000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.135000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.121000,-0.002999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005999,0.104000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005999,0.104000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.049999,0.122000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.109000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008999,0.112000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.124000,-0.004999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.114000,-0.002999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.109000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037999,0.109000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.002999,0.111000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.014999,0.117000,0.005000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.110000,0.005000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.108000,0.005000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.124000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.115000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.044999,0.111000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.002999,0.111000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.002999,0.104000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005999,0.111000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.006000,0.088000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.022999,0.083000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037999,0.118000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.002999,0.111000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.133000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.026999,0.120000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.022999,0.109999,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.123000,-0.002999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.129000,-0.002999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.123999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.123999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.123999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.116999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.123999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.123999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030999,0.104999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.095999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.121999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.121999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.121999,-0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023999,0.123999,-0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.014999,0.117999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.014999,0.117999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.020999,0.115999,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.020999,0.113999,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030999,0.118000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035999,0.119999,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023999,0.125999,-0.004999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034999,0.122999,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034999,0.100000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.020999,0.105999,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032999,0.119999,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.019000,0.098999,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012999,0.109999,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.098000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.087000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.001999,0.105000,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.124000,-0.005000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.108000,0.006999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.004999,0.106000,0.004999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017999,0.114000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.104000,0.005999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.001999,0.107000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.124000,-0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.021999,0.124000,0.003999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036999,0.104000,0.002999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 161: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036999,0.116000,0.003999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.111000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035999,0.109000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037999,0.109000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.109000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.010999,0.106000,-0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.010999,0.106000,0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024999,0.123000,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.022999,0.107000,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.003999,0.110000,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.125000,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.125000,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.125000,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.125000,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.056999,0.118000,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.009999,0.106999,-0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036999,0.106999,-0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024999,0.121999,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024999,0.108999,-0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017999,0.108999,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.118999,0.008000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.121999,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.026999,0.113999,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.113999,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.113999,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.113999,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 198: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012999,0.114999,0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032999,0.109999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037999,0.119999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037999,0.119999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.003999,0.109999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.021999,0.115999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.021999,0.097999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.006999,0.112999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039999,0.101999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035999,0.114999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 216: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.002999,0.104999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036999,0.110999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018999,0.135999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.104999,0.003999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.044999,0.125999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.134999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.108999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005999,0.104999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.022999,0.079999,0.002999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.005000,0.088999,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.057999,0.104000,0.007000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.013999,0.111000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 243: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.002999,0.111000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.116000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.122000,-0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 249: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030999,0.122000,0.006000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.121000,-0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 251: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.004999,0.116000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.109000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.113000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.100000,0.005000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.129000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027999,0.129000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032999,0.094000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.107000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.020999,0.105000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038999,0.098000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.107000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.109000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.045999,0.114000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.119000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.095000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023999,0.101000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023999,0.100000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023999,0.098000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029999,0.099000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024999,0.099000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035999,0.131000,0.005000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008999,0.118000,0.009000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.022999,0.095000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034999,0.101000,0.004000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018999,0.104000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.021999,0.114000,0.000000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019999,0.105000,-0.001999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.021999,0.110000,-0.006000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.106000,-0.000999, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.010999,0.115000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.046999,0.127000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033999,0.125000,0.001000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038999,0.110000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035999,0.125000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023999,0.096000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023999,0.098000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.098000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.098000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028999,0.098000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031999,0.098000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.114000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.114000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.114000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.007999,0.114000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.100000,0.003000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.099000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
			default: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025999,0.099000,0.002000, 0.000000,0.000000,-79.300033, 1.000000,1.000000,1.000000 ) ;
		}
	}
	else if(type == 23)//vитары
	{
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.080000,-0.118999,-0.045999, 0.000000,113.100006,0.000000, 0.717999,1.000000,0.702999 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.023000,-0.130000,-0.034000, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.023000,-0.127000,-0.034000, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.063000,-0.119000,-0.034000, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082999,-0.159000,-0.052999, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082999,-0.148999,-0.052999, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.082999,-0.120999,-0.052999, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.095999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.076999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.084999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.089999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.111999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.096999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.108999,-0.052999, -8.800000,119.000007,8.100000, 0.688000,1.000000,0.696000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.108999,-0.052999, 2.799998,119.000007,0.900001, 0.688000,1.000000,0.696000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.110999,-0.052999, 10.099999,119.000007,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.119999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.142999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.129999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.117999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.117999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.106999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.145999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.105999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.079999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.102999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.102999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.113999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.113999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.112999,-0.113999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.094999,-0.112999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.094999,-0.092999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.134999,-0.106999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.134999,-0.134999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.120999,-0.052999, 10.799995,114.099998,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.109999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.109999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.082999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.128999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.128999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.103999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.126999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.126999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.099999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.086000,-0.105999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.121999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.097999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.097999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.134999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.129999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.110999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.110999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.130999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.130999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.095999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.107000,-0.088999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.150000,-0.118999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.150000,-0.106999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.150000,-0.123999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.150000,-0.111999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.150000,-0.137999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.150000,-0.116999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.157000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.140999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.163000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.134000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.134000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.104000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.117000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.099000,-0.130000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.121000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.132000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.141000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.108000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.123000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.083000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.109000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.123000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.127000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.097000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.090000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 133: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.099000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.087000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.120000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.084000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.087000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.083000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.141000,-0.135000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.058000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 144: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.058000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.058000,-0.102000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.088000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.077000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.098000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.112000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.139000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 158: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 159: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.089000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 161: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.109000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.101000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.103000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 167: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 168: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.083000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.116000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.110000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.076000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 174: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 175: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.134000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.134000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.122000,-0.130000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.162000,-0.096000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.070000,-0.120000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.070000,-0.099000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.126000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.126000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.102000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.100000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.119000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.102000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 203: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 204: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.101000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.122999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.082000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.114000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.097000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.133000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.083000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 231: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.085000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.098000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.086000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.118000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.124000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 241: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.139000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 242: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.137000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 249: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.113000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.113000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.131000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.131000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.137000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.092000,-0.137000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.292000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 269: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.052000,-0.178000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.133000,-0.127000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.134000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.111000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.124000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.116000,-0.124000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.176000,-0.108000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.176000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.059000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.094000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.131000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
			default: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.114000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000 ) ;
		}
	}
	else if(type == 24)//Фсы 2
	{
		switch( skinid)
		{
			case 1: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036998,0.113999,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,1.000000 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.126999,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.137999,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.081998,0.137999,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064998,0.135999,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.050998,0.116999,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.139000,-0.004000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.003998,0.121000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023998,0.129000,-0.002000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012998,0.119000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.015998,0.118000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.148000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012998,0.108000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.121000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005998,0.124000,-0.002000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.127000,-0.002000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.117000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.139000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.134000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.133000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.123000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.118000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.026998,0.125000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 27: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.128000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.135000,-0.004000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.139000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.143000,-0.004000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 31: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.139000,-0.004000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027998,0.102000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.006001,0.111000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.044998,0.130000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.044998,0.114000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.042998,0.120000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.042998,0.118000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 38: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.047998,0.136000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.127000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018998,0.118000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 41: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018998,0.125000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037998,0.130000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.010998,0.120000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027998,0.143000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.026998,0.137000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030998,0.130000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.016998,0.117000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.015998,0.117000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.055998,0.137000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032998,0.123000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018998,0.124000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.136000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.127000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.130000,0.005999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.041998,0.122000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.041998,0.120000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.009998,0.125000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024998,0.130000,0.005999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.104000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.123000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.122000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.010998,0.116000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.072998,0.120000,0.006999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.120000,0.006999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038998,0.136000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.121000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038998,0.120000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.054998,0.122000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.011998,0.124000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.011998,0.117000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.011998,0.124000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.003001,0.102000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.099000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.042998,0.125000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.004998,0.122000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.026998,0.143000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.132000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.124000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.133000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037998,0.135000,-0.004000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.132000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.132000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.115000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.105000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.137000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.137000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.137000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018998,0.127000,-0.004000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.018998,0.127000,-0.004000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024998,0.127000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024998,0.123000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037998,0.129000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.042998,0.131000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.137000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.040998,0.133000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.040998,0.109000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.116000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.131000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 7, setobject, 2, -0.014001,0.115000,-0.000000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017998,0.127000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.098000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.010998,0.118000,0.001999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.134000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.040998,0.124000,0.003999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.116000,0.003999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.116000,0.003999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024998,0.128000,-0.002000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 152: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024998,0.110000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.117000,0.006999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005998,0.122000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037998,0.134000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025998,0.134000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 158: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.125000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 159: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027998,0.128000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.045998,0.114000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 161: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.041998,0.129000,0.004999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.041998,0.123000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.041998,0.121000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017998,0.123000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017998,0.122000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.013998,0.116000,0.002999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.134000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.121000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.014998,0.125000,0.000999, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038998,0.134000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.134000,-0.005000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.060998,0.130000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.017998,0.119000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.042998,0.119000,-0.001000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.136000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023998,0.125000,-0.003000, 0.000000,0.000000,67.699974, 1.000000,1.000000,0.771000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.023998,0.125000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.771000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.125000,0.005999, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.129000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027998,0.124000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032998,0.124000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032998,0.124000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032998,0.124000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032998,0.126000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032998,0.119000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.043998,0.130000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.044998,0.130000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.117000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.128000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.011998,0.123000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.044998,0.112000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.044998,0.128000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.011998,0.116000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 215: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.116000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 216: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.116000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.123000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.005998,0.120000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.016998,0.150000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 224: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.006998,0.119000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 225: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.006998,0.119000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012998,0.119000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.052998,0.137000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.148000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.032998,0.120000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.001998,0.120000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 231: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038998,0.145000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030998,0.099000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.001998,0.109000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.064998,0.113000,0.005999, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.015998,0.124000,0.002999, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 241: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012998,0.134000,0.002999, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 242: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.004998,0.120000,-0.000000, 0.000000,0.000000,76.999992, 1.000000,1.000000,0.816000 ) ;
			case 243: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.120000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.038998,0.126000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025998,0.134000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 249: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.041998,0.134000,0.005999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.031998,0.136000,-0.004000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.025998,0.123000,0.003999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.125000,0.001999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036998,0.115000,0.006999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036998,0.143000,0.002999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.143000,0.002999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.108000,0.002999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.019998,0.124000,-0.003000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.111000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.110000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.036998,0.116000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.054998,0.126000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.042998,0.131000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.108000,-0.001000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.108000,-0.001000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.110000,-0.001000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027998,0.111000,-0.001000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.034998,0.108000,-0.001000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.028998,0.109000,-0.001000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.039998,0.140000,0.006999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.033998,0.107000,-0.001000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.016998,0.129000,0.004999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.108000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.042998,0.115000,0.003999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.021998,0.118000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.027998,0.125000,0.000999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.024998,0.118000,-0.004000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.120000,-0.004000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.117000,0.001999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.014998,0.124000,0.001999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.045998,0.138000,0.001999, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.045998,0.122000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.043998,0.134000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030998,0.112000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.113000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.035998,0.108000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.111000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.029998,0.111000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.037998,0.111000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.012998,0.126000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.127000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.127000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.008998,0.127000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030998,0.109000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030998,0.109000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
			default: SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.030998,0.109000,-0.000000, 0.000000,0.000000,76.999992, 1.111000,0.927000,0.816000 ) ;
		}
	}
	else if(type == 25)
	{
		switch (skinid)//Ќовогодние шапки (19064 19065 19066)
		{
			case 1: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120999,0.000000,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140000,0.001999,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161000,0.001999,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152000,-0.004000,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152000,0.007999,-0.003000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,0.000999,-0.003000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,0.000999,0.001999, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,-0.018000,0.001999, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,0.019999,0.001999, 3.400000,87.100013,88.299980, 1.014000,1.183000,1.000000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.111000,-0.022000,0.001999, 3.400000,87.100013,88.299980, 0.920000,1.077000,1.000000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 0.920000,1.077000,1.000000 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127000,0.004999,0.001999, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127000,0.015999,0.004000, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127000,0.015999,0.004000, 3.400000,87.100013,88.299980, 1.095999,1.077000,1.000000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127000,0.024999,-0.001000, 3.400000,87.100013,88.299980, 1.172999,1.160000,1.000000 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.127000,0.016999,0.000999, 3.400000,87.100013,88.299980, 1.172999,1.160000,1.000000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,-0.008000,0.003999, 3.400000,87.100013,88.299980, 1.172999,1.178000,1.000000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,0.018999,0.003999, 3.400000,87.100013,88.299980, 0.858999,0.969000,1.000000 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,-0.012000,0.003999, 3.400000,87.100013,88.299980, 0.858999,0.990000,1.000000 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144000,0.010999,0.003999, 3.400000,87.100013,88.299980, 0.959999,1.083999,1.000000 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.144000,-0.000000,0.003999, 3.400000,87.100013,88.299980, 0.959999,1.122000,1.000000 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151000,-0.008000,-0.002000, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,0.009999,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,0.028999,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,-0.011000,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,-0.011000,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147000,0.022999,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109000,0.000999,0.004999, 3.400000,87.100013,88.299980, 0.882999,0.963999,1.000000 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.152000,-0.001000,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.006999,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.006999,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.006999,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.025999,0.001999, 3.400000,87.100013,88.299980, 0.942998,0.978999,1.001000 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,-0.012000,0.002999, 3.400000,87.100013,88.299980, 0.942998,1.102999,1.001000 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.006999,0.007000, 3.400000,87.100013,88.299980, 0.942998,1.102999,1.001000 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.006999,0.008000, 3.400000,87.100013,88.299980, 0.942998,1.102999,1.001000 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.014999,-0.001000, 3.400000,87.100013,88.299980, 0.997998,1.126000,1.001000 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.130000,-0.013000,-0.001000, 3.400000,87.100013,88.299980, 1.016998,1.159000,1.001000 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,0.009999,0.008000, 3.400000,87.100013,88.299980, 0.954998,1.135000,1.001000 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.180000,0.009999,0.008000, 3.400000,87.100013,88.299980, 0.976998,1.135000,1.001000 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.172000,0.001999,0.008000, 3.400000,87.100013,88.299980, 1.003998,1.135000,1.001000 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.175000,-0.001000,0.008000, 3.400000,87.100013,88.299980, 1.005998,1.018000,1.001000 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.005998,1.018000,1.001000 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.108998,1.145000,1.001000 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.135998,1.145000,1.044000 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,-0.013000,0.001999, 3.400000,87.100013,88.299980, 0.939998,1.133000,1.044000 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.016999,0.003000, 3.400000,87.100013,88.299980, 1.019998,1.160000,1.044000 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.117000,0.001999,0.003000, 3.400000,87.100013,88.299980, 1.055998,1.104000,1.044000 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,0.019999,0.003000, 3.400000,87.100013,88.299980, 1.055998,1.104000,1.044000 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,0.011999,0.005000, 3.400000,87.100013,88.299980, 1.116998,1.189000,1.044000 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,0.008999,0.005000, 3.400000,87.100013,88.299980, 1.116998,1.189000,1.044000 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,0.008999,-0.000999, 3.400000,87.100013,88.299980, 1.116998,1.320001,1.044000 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,0.003999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.132000,0.003999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147000,-0.010000,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.138000,0.001999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139000,0.006999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134000,0.009000,0.000000, 1.699999,90.200042,89.400001, 1.000000,1.000000,1.000000 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.099000,0.009000,0.000000, 1.699999,90.200042,89.400001, 1.000000,1.000000,1.000000 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145999,0.005000,0.000000, 1.699999,90.200042,89.400001, 1.012999,1.100999,1.000000 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.145999,0.005000,0.000000, 1.699999,90.200042,89.400001, 1.062999,1.139999,1.000000 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,0.018999,0.000000, 1.699999,90.200042,89.400001, 0.937999,1.009999,1.000000 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,0.018999,0.000000, 1.699999,90.200042,89.400001, 0.937999,1.009999,1.000000 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133999,0.010999,0.000999, 1.699999,90.200042,89.400001, 0.937999,1.099999,1.000000 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133999,-0.003000,0.000999, 1.699999,90.200042,89.400001, 1.072000,1.099999,1.000000 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133999,0.000999,0.000999, 1.699999,90.200042,89.400001, 1.072000,1.148000,1.000000 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133999,0.000999,0.000999, 1.699999,90.200042,89.400001, 0.972000,1.061000,1.000000 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141000,0.000999,-0.003000, 1.699999,90.200042,89.400001, 1.165000,1.223000,1.000000 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141000,0.006999,0.003999, 1.699999,90.200042,89.400001, 1.056000,1.085000,1.000000 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.120999,0.006999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.085000,1.000000 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134000,0.000999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134000,0.010999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150000,0.010999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000 ) ;
			case 131: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.109000,0.010999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.042000,0.000999,-0.000000, 1.699999,90.200042,89.400001, 0.942000,0.921000,1.000000 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133000,0.000999,-0.001000, 1.699999,90.200042,89.400001, 0.942000,1.146000,1.000000 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.129000,-0.013000,0.008999, 1.699999,90.200042,89.400001, 0.942000,1.009000,1.000000 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139000,-0.024000,0.008999, 1.699999,90.200042,89.400001, 0.942000,1.129000,1.000000 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.139000,-0.029000,0.000999, 1.699999,90.200042,89.400001, 0.992000,1.235000,1.000000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,-0.007000,0.000999, 1.699999,90.200042,89.400001, 0.992000,1.029000,1.000000 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.165000,-0.034000,0.000999, 1.699999,90.200042,89.400001, 0.992000,1.198000,1.000000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,-0.000000,0.000999, 1.699999,90.200042,89.400001, 1.047000,1.198000,1.000000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.118000,0.003999,0.000999, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147000,0.003999,0.000999, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.003999,0.000999, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.003999,-0.001000, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.128000,0.003999,-0.001000, 1.699999,90.200042,89.400001, 0.886000,1.061999,1.000000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126000,0.003999,-0.001000, 1.699999,90.200042,89.400001, 0.886000,1.061999,1.000000 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126000,-0.013000,-0.001000, 1.699999,90.200042,89.400001, 1.030000,1.197999,1.000000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126000,0.001999,-0.001000, 1.699999,90.200042,89.400001, 0.985000,1.197999,1.000000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.141000,-0.005000,-0.001000, 1.699999,90.200042,89.400001, 1.070000,1.092000,1.000000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136000,-0.005000,-0.001000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136000,-0.000000,-0.001000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.137000,0.004999,-0.001000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.159000,-0.009000,-0.003000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.909000,1.015999,1.000000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.106999,1.000000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126000,0.004999,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.149000,-0.009000,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.148000,-0.009000,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.112000,-0.009000,0.004999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122000,0.004999,0.004999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.136000,-0.000000,0.004999, 4.000000,90.900016,84.900016, 1.079001,1.112000,1.070999 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153000,-0.015000,0.004999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153000,-0.015000,0.004999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153000,-0.006000,0.004999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.153000,-0.006000,0.000999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140000,-0.006000,0.000999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140000,0.020999,0.000999, 4.000000,90.900016,84.900016, 0.903001,1.018000,1.070999 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.090000,0.005999,0.000999, 4.000000,90.900016,84.900016, 0.903001,1.018000,1.070999 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.113000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.903001,1.018000,1.070999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.126000,0.007999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.116000,1.070999 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.140000,0.007999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.116000,1.070999 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103000,0.023999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.116000,1.070999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.154000,-0.011000,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.283000,1.070999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.151000,-0.024000,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.283000,1.070999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.161000,0.002999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.113000,1.070999 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122000,-0.016000,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122000,0.026999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.147000,0.001999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.101000,0.001999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.067000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.900001,1.023000,1.070999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.110000,-0.001000,0.000999, 4.000000,90.900016,84.900016, 0.900001,1.023000,1.070999 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146000,-0.001000,0.000999, 4.000000,90.900016,84.900016, 0.995001,1.180000,1.070999 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.146000,-0.003000,0.000999, 4.000000,90.900016,84.900016, 1.114001,1.180000,1.070999 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.174000,-0.003000,0.000999, 4.000000,90.900016,84.900016, 1.114001,1.180000,1.070999 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.125000,0.007999,-0.007000, 4.000000,90.900016,84.900016, 1.022000,1.180000,1.070999 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134000,0.004999,-0.007000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142000,0.000999,-0.001000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142000,0.000999,-0.001000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.142000,0.000999,-0.001000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.122000,0.009999,-0.001000, 4.000000,90.900016,84.900016, 0.954001,1.015000,1.070999 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.103000,0.009999,-0.001000, 4.000000,90.900016,84.900016, 0.954001,1.015000,1.070999 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114000,0.009999,-0.001000, 4.000000,90.900016,84.900016, 0.954001,1.190000,1.070999 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.104000,0.002999,-0.001000, 4.000000,90.900016,84.900016, 1.005001,1.190000,1.070999 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.114000,0.002999,-0.001000, 4.000000,90.900016,84.900016, 1.005001,1.190000,1.070999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.133000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.005001,1.190000,1.070999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.099000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.150000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.141000,1.131000,1.070999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.098000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 0.912000,1.110000,1.070999 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143000,0.004999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.110000,1.070999 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.004999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.110000,1.070999 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.143000,-0.021000,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.110000,1.070999 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155000,-0.010000,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.155000,0.012999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.012999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.012999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.014999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.090000,1.070999 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.090000,1.070999 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.194000,1.070999 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.194000,1.070999 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.194000,1.070999 ) ;
			default: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.194000,1.070999 ) ;
		}
	}
	else if(type == 26)
	{
		switch (skinid)//ѕиратска¤ пов¤зка (19085)
		{
			case 1: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.102999,0.020000,-0.003999, -2.900000,91.700050,94.000015, 0.911999,1.068999,1.000000 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.087999,0.038000,-0.003999, -2.900000,91.700050,94.000015, 0.911999,1.068999,1.000000 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.094999,0.036000,-0.003999, -2.900000,91.700050,94.000015, 0.987000,1.141999,1.000000 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.121000,0.023000,-0.004999, -52.799995,103.800048,143.000045, 0.987000,1.141999,1.000000 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.102000,0.025000,-0.004999, -52.799995,103.800048,143.000045, 1.080000,1.207999,1.000000 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.076000,0.035000,-0.003999, -52.799995,103.800048,142.700042, 0.952000,1.031999,0.780000 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.076999,0.048999,-0.006999, -52.799995,103.800048,142.700042, 0.952000,1.151999,0.866000 ) ;
			case 8: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.068000,0.033999,-0.006999, -52.799995,103.800048,142.700042, 0.952000,1.151999,0.866000 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.042000,0.033999,-0.006999, -52.799995,103.800048,142.700042, 0.952000,1.151999,0.866000 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050000,0.036999,-0.006999, -52.799995,103.800048,142.700042, 0.952000,1.151999,0.866000 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050000,0.040999,-0.006999, -52.799995,103.800048,142.700042, 0.952000,1.151999,0.866000 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050000,0.034999,-0.006999, -52.799995,103.800048,142.700042, 0.952000,1.151999,0.866000 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.063999,0.032999,-0.006999, -52.799995,103.800048,142.700042, 0.952000,1.151999,0.866000 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.078999,0.038999,0.002000, -52.799995,103.800048,142.700042, 1.049000,1.184000,0.866000 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.058000,0.001999,-0.005999, -52.799995,103.800048,142.700042, 1.049000,1.184000,0.866000 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.068999,0.028000,-0.005999, -52.799995,103.800048,142.700042, 1.049000,1.184000,0.866000 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.068999,0.028000,-0.005999, -52.799995,103.800048,142.700042, 1.049000,1.184000,0.866000 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074000,0.024000,-0.005999, -57.499988,103.800048,145.000152, 1.049000,1.184000,0.866000 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074000,0.034000,-0.005999, -57.499988,103.800048,145.000152, 1.049000,1.184000,0.866000 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074000,0.034000,-0.005999, -57.499988,103.800048,145.000152, 1.049000,1.184000,0.866000 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.078000,0.032000,-0.005999, -57.499988,103.800048,145.000152, 1.049000,1.184000,0.866000 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071000,0.033000,0.003000, -57.499988,103.800048,145.000152, 0.945000,1.044000,0.866000 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071000,0.030000,0.003000, -57.499988,103.800048,145.000152, 0.945000,1.044000,0.866000 ) ;
			case 26: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.033000,-0.000999, -57.499988,103.800048,145.000152, 0.948000,1.050999,0.866000 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071999,0.039000,-0.000999, -57.499988,103.800048,145.000152, 0.916000,1.050999,0.866000 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.080999,0.048000,0.000000, -57.499988,103.800048,145.000152, 0.916000,1.050999,0.866000 ) ;
			case 31: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071999,0.050000,0.000000, -57.499988,103.800048,145.000152, 0.916000,1.050999,0.866000 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.013999,0.017000,0.000000, -57.499988,103.800048,145.000152, 0.916000,0.944999,0.755000 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.075999,0.028000,0.002000, -57.499988,103.800048,145.000152, 0.916000,0.944999,0.755000 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.075999,0.028000,0.002000, -57.499988,103.800048,145.000152, 0.916000,0.944999,0.755000 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.075999,0.028000,0.002000, -57.499988,103.800048,145.000152, 0.964000,0.976999,0.755000 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.052000,0.028000,0.002000, -57.499988,103.800048,145.000152, 0.964000,0.976999,0.755000 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.073000,0.035000,-0.003999, -57.499988,103.800048,145.000152, 0.848000,1.011999,0.814999 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071000,0.066000,-0.003999, -57.499988,103.800048,145.000152, 0.848000,1.111000,0.814999 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.055000,0.037000,-0.003999, -57.499988,103.800048,145.000152, 0.848000,1.111000,0.814999 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.072999,0.026000,-0.003999, -57.499988,103.800048,145.000152, 0.848000,1.018000,0.814999 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.063000,0.046000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.075999,0.049000,-0.006999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.067999,0.040000,-0.006999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.078999,0.036000,0.000000, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.078999,0.036000,0.000000, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.040000,0.000000, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.055999,0.044000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.045000,0.004000, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.030000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.067999,0.052000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.067999,0.052000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.055999,0.041000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.093999,0.814999 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.093999,0.021000,0.004000, -57.499988,103.800048,145.000152, 0.870000,0.997999,0.814999 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.068999,0.031000,0.004000, -57.499988,103.800048,145.000152, 0.870000,0.997999,0.814999 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.076999,0.037000,-0.001999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.048999,0.045000,-0.001999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.048999,0.040000,-0.001999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.048999,0.046000,-0.007999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.010000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.081999,0.034000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.047999,0.032000,-0.007999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.072999,0.062000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.072999,0.039000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.072999,0.044000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.082999,0.044000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.082999,0.046000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.082999,0.046000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.082999,0.046000,-0.006999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.079000,0.033000,-0.004999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.079000,0.046000,-0.007999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.079000,0.046000,-0.007999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.079000,0.035000,-0.007999, -57.499988,103.800048,145.000152, 0.870000,1.127999,0.814999 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.075000,0.025000,-0.003999, -57.499988,103.800048,145.000152, 0.870000,1.007999,0.814999 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.085999,0.047000,-0.003999, -57.499988,103.800048,145.000152, 0.890999,1.152999,0.814999 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.069000,0.042000,-0.002999, -57.499988,103.800048,145.000152, 0.890999,1.152999,0.814999 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.059000,0.042000,-0.002999, -57.499988,103.800048,145.000152, 0.890999,1.152999,0.814999 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.059000,0.042000,-0.002999, -57.499988,103.800048,145.000152, 0.890999,1.152999,0.814999 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.073999,0.038000,-0.005999, -57.499988,103.800048,145.000152, 0.890999,1.152999,0.814999 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.068999,0.038000,-0.005999, -57.499988,103.800048,145.000152, 0.890999,1.152999,0.814999 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.068999,0.039000,-0.003999, -57.499988,103.800048,145.000152, 0.890999,1.191999,0.814999 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071000,0.039000,-0.003999, -57.499988,103.800048,145.000152, 0.890999,1.191999,0.814999 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.079999,0.039000,-0.006999, -57.499988,103.800048,145.000152, 0.890999,1.191999,0.814999 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.076999,0.035000,-0.006999, -57.499988,103.800048,145.000152, 0.890999,1.089999,0.814999 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.076999,0.035000,-0.006999, -57.499988,103.800048,145.000152, 0.890999,1.191999,0.814999 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.076999,0.045000,-0.006999, -57.499988,103.800048,145.000152, 0.890999,1.191999,0.814999 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.082000,0.052000,-0.006999, -57.499988,103.800048,145.000152, 0.890999,1.191999,0.814999 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.010999,0.015000,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.059999,0.814999 ) ;
			case 133: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084000,0.042000,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.059999,0.814999 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.076000,0.022000,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.059999,0.814999 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.057000,0.033000,-0.000999, -57.499988,103.800048,145.000152, 0.843999,1.019999,0.814999 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070000,0.023000,0.001000, -57.499988,103.800048,145.000152, 0.843999,1.019999,0.814999 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.052000,0.011000,0.001000, -57.499988,103.800048,145.000152, 0.843999,1.019999,0.814999 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.087000,0.048999,-0.002999, -57.499988,103.800048,145.000152, 0.843999,1.019999,0.814999 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.080000,0.028000,0.004000, -57.499988,103.800048,145.000152, 0.843999,1.019999,0.857000 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066000,0.022999,0.004000, -57.499988,103.800048,145.000152, 0.843999,0.962999,0.857000 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.045000,0.040999,-0.006999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.082000,0.044999,-0.004999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.057000,0.050999,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 158: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.067000,0.032999,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 159: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.067000,0.039999,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.079000,0.023999,-0.002999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 161: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084000,0.042999,0.007000, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084000,0.047999,0.000000, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.075000,0.035999,-0.005999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.077000,0.032999,-0.005999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066000,0.044999,-0.004999, -57.499988,103.800048,145.000152, 0.843999,1.005999,0.857000 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.058000,0.036999,-0.002999, -57.499988,103.800048,145.000152, 0.922999,1.066999,0.857000 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070000,0.045999,-0.009999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070000,0.033999,-0.005999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.044000,0.039999,-0.005999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071000,0.039999,-0.005999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 175: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071000,0.039999,-0.005999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084000,0.039999,-0.008999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084000,0.039999,-0.008999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.079000,0.039999,-0.008999, -57.499988,103.800048,145.000152, 0.922999,1.115999,0.857000 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.083000,0.039999,-0.008999, -57.499988,103.800048,145.000152, 0.922999,1.168999,0.857000 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.107000,0.039999,-0.005999, -57.499988,103.800048,145.000152, 0.822999,1.092998,0.857000 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.063000,0.042999,-0.005999, -57.499988,103.800048,145.000152, 0.822999,1.092998,0.857000 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.080999,0.034999,-0.005999, -57.499988,103.800048,145.000152, 0.822999,1.092998,0.857000 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.080999,0.051999,-0.007999, -57.499988,103.800048,145.000152, 0.822999,1.092998,0.857000 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074999,0.043999,-0.000999, -57.499988,103.800048,145.000152, 0.822999,1.092998,0.857000 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.073999,0.033999,0.005000, -57.499988,103.800048,145.000152, 0.822999,1.092998,0.857000 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084999,0.040999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.048999,0.857000 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.043999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.046999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.046999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.046999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.046999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.046999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.044999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.080999,0.025999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.089999,0.047999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.089999,0.047999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.042999,0.039999,-0.004999, -57.499988,103.800048,145.000152, 0.822999,1.103999,0.857000 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.022999,-0.003999, -57.499988,103.800048,145.000152, 0.822999,1.006999,0.857000 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050999,0.054999,-0.003999, -57.499988,103.800048,145.000152, 0.822999,1.006999,0.857000 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.072999,0.030999,-0.003999, -57.499988,103.800048,145.000152, 0.822999,1.006999,0.857000 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.086999,0.039999,0.002000, -57.499988,103.800048,145.000152, 0.843999,1.047999,0.857000 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.080999,0.037999,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.047999,0.857000 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.033999,0.052999,-0.001999, -57.499988,103.800048,145.000152, 0.843999,1.047999,0.857000 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074999,0.038999,-0.001999, -57.499988,103.800048,145.000152, 0.902999,1.143998,0.857000 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074999,0.038999,-0.001999, -57.499988,103.800048,145.000152, 0.902999,1.143998,0.857000 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074999,0.061999,-0.003999, -57.499988,103.800048,145.000152, 0.899999,1.153998,0.857000 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.089999,0.050999,-0.007999, -57.499988,103.800048,145.000152, 0.899999,1.127998,0.857000 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.086999,0.057999,-0.004999, -57.499988,103.800048,145.000152, 0.899999,1.127998,0.857000 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.025999,-0.004999, -57.499988,103.800048,145.000152, 0.899999,1.127998,0.857000 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.035999,0.030999,-0.002999, -57.499988,103.800048,145.000152, 0.899999,1.013998,0.759999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.034999,0.017999,-0.005999, -57.499988,103.800048,145.000152, 0.899999,1.032998,0.759999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.028999,-0.001999, -57.499988,103.800048,145.000152, 0.899999,1.070998,0.759999 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.098999,0.014999,0.000000, -57.499988,103.800048,145.000152, 0.899999,1.026998,0.759999 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.086999,0.036999,-0.000999, -57.499988,103.800048,145.000152, 0.899999,1.104998,0.867999 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074999,0.049999,-0.000999, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 251: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.052999,0.046999,-0.004999, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.081999,0.038999,-0.004999, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084999,0.037999,0.000000, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.062999,0.014999,0.000000, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071999,0.047999,-0.001999, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071999,0.047999,-0.001999, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.059999,0.034999,-0.006999, -57.499988,103.800048,145.000152, 0.899999,1.141998,0.867999 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.068999,0.025999,-0.003999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.084999,0.017999,-0.003999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.074999,0.023999,-0.003999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.078999,0.031999,-0.003999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.088999,0.036999,-0.003999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.057999,0.033999,-0.001999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.025999,-0.006999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.025999,-0.006999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.025999,-0.006999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.025999,-0.006999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.025999,-0.006999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.025999,-0.006999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.066999,0.025999,-0.006999, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 285: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.083999,0.034999,0.004000, -57.499988,103.800048,145.000152, 0.905000,1.073998,0.867999 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.055999,0.036999,0.007000, -57.499988,103.800048,145.000152, 0.905000,1.056998,0.867999 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.065999,0.019999,-0.002999, -57.499988,103.800048,145.000152, 0.948000,1.056998,0.867999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.080999,0.034999,-0.002999, -57.499988,103.800048,145.000152, 0.948000,1.056998,0.867999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.061999,0.021999,-0.006999, -57.499988,103.800048,145.000152, 0.948000,1.056998,0.867999 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.070999,0.029999,-0.008999, -57.499988,103.800048,145.000152, 0.977999,1.027998,0.867999 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.056999,0.026999,-0.001999, -57.499988,103.800048,145.000152, 1.076999,1.143998,0.867999 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.090999,0.012999,-0.001999, -57.499988,103.800048,145.000152, 1.076999,1.143998,0.867999 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.078999,0.021999,-0.000999, -57.499988,103.800048,145.000152, 1.163999,1.255998,0.867999 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.078999,0.034999,-0.005999, -57.499988,103.800048,145.000152, 1.052999,1.174998,0.867999 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.024999,-0.005999, -57.499988,103.800048,145.000152, 0.945999,1.057998,0.867999 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.024999,-0.005999, -57.499988,103.800048,145.000152, 0.945999,1.057998,0.867999 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.024999,-0.005999, -57.499988,103.800048,145.000152, 0.945999,1.057998,0.867999 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.029999,-0.005999, -57.499988,103.800048,145.000152, 0.895999,1.057998,0.867999 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.029999,-0.005999, -57.499988,103.800048,145.000152, 0.895999,1.057998,0.867999 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.064999,0.029999,-0.005999, -57.499988,103.800048,145.000152, 0.895999,1.057998,0.867999 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050999,0.037999,-0.006999, -57.499988,103.800048,145.000152, 0.981998,1.121998,0.867999 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050999,0.037999,-0.006999, -57.499988,103.800048,145.000152, 0.981998,1.121998,0.867999 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050999,0.037999,-0.006999, -57.499988,103.800048,145.000152, 0.981998,1.121998,0.867999 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.050999,0.033999,-0.006999, -57.499988,103.800048,145.000152, 0.981998,1.121998,0.867999 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071999,0.028999,-0.004999, -57.499988,103.800048,145.000152, 0.923998,1.033998,0.867999 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071999,0.028999,-0.004999, -57.499988,103.800048,145.000152, 0.923998,1.033998,0.867999 ) ;
			default: SetPlayerAttachedObject ( playerid, 8, setobject, 2, 0.071999,0.028999,-0.004999, -57.499988,103.800048,145.000152, 0.923998,1.033998,0.867999 ) ;
		}
	}
	else if(type == 27)
	{
		switch (skinid)//Ќовогодний рюкзак (19054 19055 19056 19057 19058)
		{
			case 1..4: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.078000,-0.128999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.078000,-0.213999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 6..8: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.078000,-0.195999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.078000,-0.170999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 10: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.009999,-0.181999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 11: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115000,-0.140999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.051999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.108999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 16: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.191999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.174999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.152999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.063999,-0.173999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.083999,-0.173999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.083999,-0.173999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.060999,-0.173999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.060999,-0.173999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 38: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018999,-0.153999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 39: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.018999,-0.182999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.079999,-0.150999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 41: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.102999,-0.146999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 42: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.069999,-0.156999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.043999,-0.156999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.043999,-0.156999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.077999,-0.165999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107999,-0.169999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107999,-0.182999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107999,-0.182999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107999,-0.158999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.058999,-0.142999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.058999,-0.142999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.144999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.065999,-0.151999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.124999,-0.151999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.092999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.092999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 65: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 66: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.154999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.115999,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.092999,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.092999,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 74: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.092999,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.092999,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 77: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.066000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.127000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.127000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 85: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.148999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.075000,-0.148999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.152999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.026000,-0.156999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.065000,-0.156999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.143999,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.100000,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.100000,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.100000,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.153000,-0.182999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.097000,-0.182999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.097000,-0.201999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.060000,-0.201999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.201999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.201999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.201999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.182999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.209999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.196999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.196999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.171999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.189999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.189999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.167999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.160999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 133: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.108000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.108000,-0.172999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.108000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.053000,-0.162999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.162999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.162999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.184999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.178999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 144: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.080000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.151999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.160999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 149: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.206999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.155999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.184999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 152: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.153999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.173999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.173999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.191999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.181999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 158: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.181999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 159: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.181999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.155999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 161: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.082000,-0.177999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.127000,-0.177999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.112000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.112000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.033000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 167: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 168: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.186999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.156999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.179999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 174: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.179999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 175: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.179999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.073000,-0.194999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.073000,-0.194999,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.167998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.184998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.110000,-0.164998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.176998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.176998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.176998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.176998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.182998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.172998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.172998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.172998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.172998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.098000,-0.172998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.145000,-0.159998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.145000,-0.159998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.145000,-0.159998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.125000,-0.163998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 196: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.001000,-0.173998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 197: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.043000,-0.187998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 198: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.156000,-0.157998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 199: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.046000,-0.179998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.179998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 201: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.179998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.179998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.179998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.179998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.187998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.117000,-0.153998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.074000,-0.153998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.074000,-0.185998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.074000,-0.185998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.108000,-0.153998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.066000,-0.182998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.066000,-0.182998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.066000,-0.182998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.120000,-0.182998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 224: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.120000,-0.151998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 225: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.120000,-0.151998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.076000,-0.151998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.135000,-0.186998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.135000,-0.186998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.078000,-0.156998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.078000,-0.156998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 233: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.097000,-0.156998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.097000,-0.156998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.097000,-0.156998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.097000,-0.156998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.128000,-0.176998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.176998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 241: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.192998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 242: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.192998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 243: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.174998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.179998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.192998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 249: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.178998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.186998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.167998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.172998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.090000,-0.172998,0.000000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 256: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107000,-0.165998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 257: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107000,-0.165998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107000,-0.165998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107000,-0.180998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 260: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.107000,-0.180998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.046000,-0.164998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.088000,-0.175998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 264: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.088000,-0.175998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.088000,-0.187998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.088000,-0.187998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.239000,-0.187998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.122000,-0.187998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 269: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.089000,-0.223998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 270: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.185998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 271: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.101000,-0.198998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 272: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.058000,-0.198998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 273: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.058000,-0.198998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 274: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.198998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 275: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.198998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 276: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.198998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 277: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.210998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 278: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.210998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 285: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.118000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.096000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.096000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 288: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.096000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.096000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.096000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.096000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.096000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.137000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.137000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.058000,-0.180998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.058000,-0.180998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.058000,-0.180998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.180998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.190998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.149000,-0.155998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.155998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.155998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.155998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.155998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.155998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
			default: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.104000,-0.155998,-0.001000, 0.000000,85.899986,0.000000, 0.240000,0.181000,0.398999 ) ;
		}
	}
	else if(type == 28)
	{
		switch (skinid)//Ќовогодн¤¤ Єлка (881)
		{
			case 1: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.286000,-0.134000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 2: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.286000,-0.134000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 3: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.286000,-0.134000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 4: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.286000,-0.134000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 5: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.229000,-0.171000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 6: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.274999,-0.171000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 7: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.274999,-0.171000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 8: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.274999,-0.171000,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 9: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.273999,-0.094999,-0.045999, 7.900006,84.100006,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 12: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.273999,-0.134999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 13: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.220999,-0.134999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 14: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.286999,-0.116999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 15: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.286999,-0.116999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 16: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.116999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 17: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.113999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 18: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.113999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 19: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 20: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 21: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 22: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 23: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 24: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 25: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 28: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 29: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.163999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 30: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.135999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 32: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.105999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 33: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.105999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 34: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.105999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 35: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 36: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 37: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.127999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 40: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.110999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 42: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.252999,-0.110999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.286998,0.195998 ) ;
			case 43: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.327000,-0.110999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.258998,0.195998 ) ;
			case 44: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.327000,-0.110999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.258998,0.195998 ) ;
			case 45: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.310000,-0.110999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.258998,0.195998 ) ;
			case 46: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.310000,-0.153999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.258998,0.195998 ) ;
			case 47: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.272000,-0.153999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.258998,0.195998 ) ;
			case 48: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.272000,-0.138999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.258998,0.195998 ) ;
			case 49: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.272000,-0.128999,0.117001, 10.100007,100.700004,17.700008, 0.379999,0.258998,0.195998 ) ;
			case 50: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.238000,-0.140999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 54: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.238000,-0.119999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 55: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.238000,-0.119999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 56: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.238000,-0.119999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 57: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.238000,-0.119999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 58: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.238000,-0.112999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 59: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.238000,-0.112999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 60: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.220000,-0.126999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 61: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.259000,-0.126999,0.117001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 62: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.126999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 65: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 67: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 68: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 69: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 70: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 71: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 72: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 73: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.121999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 76: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.113999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 77: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.113999,0.132001, 10.100007,100.700004,-59.800003, 0.379999,0.258998,0.195998 ) ;
			case 78: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.152999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 79: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.152999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 80: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.152999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 81: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.152999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 82: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 83: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 84: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 85: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 86: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.236999,-0.159999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 89: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.283999,-0.153999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 90: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.239999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 91: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.239999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 93: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.239999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 94: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.239999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 95: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.239999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 96: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.239999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 97: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.243999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 98: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.243999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 99: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.243999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 100: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.243999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 101: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.243999,-0.167999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 102: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.243999,-0.156999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 103: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.183999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 104: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.167999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 105: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.167999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 106: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.167999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 107: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.167999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 108: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 109: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 110: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 111: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 112: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 113: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 114: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 115: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 116: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 117: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.146999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 118: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.146999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 119: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.146999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 120: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.155999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 121: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.167999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 122: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.132999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 123: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.145999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 124: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.113999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 125: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.129999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 126: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.149999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 127: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.151999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 128: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.125999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 129: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.117999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 130: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.129999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 131: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.112999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 132: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.112999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 133: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.130999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 134: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.125999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 135: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.227999,-0.139999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 136: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.281999,-0.110999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 137: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.281999,-0.125999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 138: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.281999,-0.106999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 139: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.107999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 140: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.107999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 141: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.107999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 142: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.160999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 143: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.160999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 144: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.160999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 145: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.105999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 146: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.140999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 147: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.128999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 148: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.121999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 149: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.205999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 150: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.124999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 151: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.139999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 152: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 153: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.132999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 154: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.138999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 155: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.158999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 156: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.138999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 157: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.110999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 158: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 159: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 160: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.126999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 161: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.134999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 162: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.134999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 163: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.134999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 164: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.131999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 165: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.142999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 166: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.142999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 167: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.142999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 168: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.142999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 169: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.122999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 170: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.136999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 171: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.136999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 172: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.118999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 173: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.138999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 176: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.163999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 177: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.163999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 179: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 180: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.151999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 181: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.129999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 182: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.149999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 183: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.125999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 184: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 185: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 186: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 187: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 188: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 189: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.135999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 190: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.113999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 191: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.111999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 192: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.114999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 193: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.107999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 194: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 195: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.122999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 196: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.108999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 197: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.130999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 198: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.113999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 199: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.126999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 200: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.126999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 201: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.126999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 202: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.126999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 203: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.136999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 204: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.136999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 206: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.136999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 207: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.136999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 208: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 209: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 210: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 211: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 212: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 213: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.149999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 214: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 215: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 216: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 217: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.130999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 218: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.130999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 219: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 220: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.147999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 221: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.138999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 222: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.138999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 223: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.155999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 224: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 225: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 226: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 227: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.158999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 228: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.142999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 229: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.117999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 230: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.117999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 231: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.128999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 232: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.139999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 234: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 235: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 236: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 237: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 238: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.115999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 239: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.157999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 240: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.145999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 241: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.165999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 242: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.165999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 243: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.146999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 244: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.130999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 247: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 248: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 249: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 250: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.143999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 251: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.112999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 252: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.122999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 253: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.122999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 254: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.137999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 255: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.130999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 256: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.120999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 258: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.155999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 259: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.155999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 260: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.155999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 261: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.125999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 262: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.144999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 263: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.116999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 264: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.156999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 265: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.156999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 266: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.253999,-0.156999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 267: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.149999,-0.156999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 268: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.156999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 269: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.201999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 280: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.159999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 281: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.151999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 282: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.151999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 283: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.151999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 284: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.151999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 285: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.151999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 286: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.167999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 287: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.194999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 289: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.154999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 290: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.154999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 291: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.154999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 292: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.154999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 293: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.146999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 294: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.161999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 295: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.149999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 296: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.149999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 297: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.149999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 298: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.149999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 299: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.158999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 300: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 301: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 302: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 303: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 304: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 305: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.150999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 306: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.114999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 307: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.114999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 308: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.114999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 309: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.114999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 310: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.142999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			case 311: SetPlayerAttachedObject ( playerid, 6, setobject, 1,  -0.309999,-0.142999,0.132001, 10.100007,110.399986,-17.700010, 0.379999,0.258998,0.195998 ) ;
			default: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.071999,0.028999,-0.004999, -57.499988,103.800048,145.000152, 0.923998,1.033998,0.867999 ) ;
		}
	}
	else if(type == 29)
	{
		switch (skinid)//„имодан (19624)
		{
			case 1: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.069000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 2: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.068000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 3: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.068000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 4: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.109000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 5: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.132000,0.013000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 6: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.013000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 7: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 8: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 9: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 10: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 11: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 12: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 13: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 14: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 15: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.069000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 16: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.069000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 17: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.069000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 18: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.074000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 19: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.074000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 20: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.074000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 21: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 22: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 23: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 24: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 25: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 26: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 27: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 28: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 29: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 30: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 31: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 32: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.029000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 33: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.022000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 34: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.031000,0.022000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 35: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.063000,0.031000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 36: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.063000,0.031000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 37: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.063000,0.031000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 38: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 39: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 40: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 41: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 42: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.080000,0.026000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 43: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.080000,0.021999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 44: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 45: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 46: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 47: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 48: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 49: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 50: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.015999,-0.002000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 51: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 52: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 53: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 54: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 59: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 60: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 61: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 62: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 63: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 64: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 65: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 66: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 67: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 68: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 69: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 70: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 71: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 72: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 73: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 74: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 75: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.015000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 76: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.015000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 77: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 78: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 79: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 80: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 81: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 82: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 83: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.023000,0.028000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 84: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 85: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.083000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 86: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 87: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 88: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,-0.009999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 89: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,-0.009999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 90: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 91: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 92: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 93: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 94: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 95: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 96: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 97: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 98: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 99: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 100: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 101: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 102: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 103: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 104: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 105: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 106: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 107: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 108: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 109: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 110: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 111: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 112: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 113: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 114: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 115: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 116: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 117: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 118: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 119: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.079000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 120: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 121: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 122: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 123: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 124: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 125: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 126: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 127: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.024000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 128: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 129: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 130: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 131: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 132: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 133: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 134: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 135: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.087000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 136: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.076000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 137: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 138: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 139: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 140: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 141: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 142: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 143: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 144: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 145: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.032000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 146: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.108000,0.032000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 147: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.104000,0.036999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 148: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.104000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 149: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.094000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 150: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.101000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 151: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.101000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 152: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.101000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 153: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.081000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 154: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.102000,0.016999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 155: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.102000,0.016999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 156: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.102000,0.016999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 157: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.091000,0.009999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 158: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.009999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 159: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.018999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 160: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.089000,0.018999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 161: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.097000,0.018999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 162: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 163: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 164: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 165: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 166: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 167: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 168: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 169: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 170: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 171: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 172: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 173: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 174: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 175: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 176: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 177: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 178: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 179: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.022000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 180: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.015000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 181: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.015000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 182: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.090000,0.026999,0.015000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 183: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.081000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 184: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.021000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 185: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.021000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 186: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 187: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 188: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 189: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 190: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 191: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 192: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 193: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 194: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 195: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 196: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 197: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 198: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 199: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 200: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 201: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 202: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 203: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 204: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 205: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 206: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 207: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 208: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 209: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 210: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 211: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 212: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.093000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 213: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.093000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 214: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.093000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 215: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.111000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 216: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.111000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 217: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 218: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 219: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.099000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 220: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.109000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 221: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 222: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 223: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 224: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 225: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 226: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 227: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 228: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 229: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 230: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 231: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 232: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 233: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 234: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 235: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 236: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 237: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 238: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 239: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 240: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 241: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 242: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 243: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 244: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 245: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 246: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 247: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 248: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 249: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 250: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 251: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 252: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 253: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 254: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 255: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 256: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 257: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 258: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 259: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 260: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 261: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 262: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 263: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 264: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 265: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.102000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 266..310: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			case 311: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
			default: SetPlayerAttachedObject (playerid, 9, setobject, 5,  0.077000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000 ) ;
		}
	}
	else if(type == 59)
	{
	    SetPlayerAttachedObject ( playerid, 6, setobject, 1,  0.020999, -0.157999, 0.000000, 2.600018, 88.099914, 85.399894, 0.821000, 0.705000, 0.635000);
	}
	else if(type == 32)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.146999,-0.155000,-0.012000,-88.499992,-4.499999,-42.999996,0.607999,0.582000,1.000000);
	}
 	else if(type == 33)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.011999,-0.184000,-0.119999,-0.399999,14.800000,-1.299999,1.000000,1.000000,1.000000);
	}
 	else if(type == 34)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.093000,-0.184000,0.016000,4.100003,60.199981,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 35)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.088999,-0.117000,-0.021000,2.000000,-23.900011,-79.199974,1.000000,1.000000,1.000000);
	}
 	else if(type == 36)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.101999,-0.140000,-0.105999,0.000000,-27.400001,90.199966,1.000000,1.000000,1.000000);
	}
 	else if(type == 37)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.001000,-0.130999,-0.039000,2.300007,-20.200027,91.899940,1.000000,1.000000,1.000000);
	}
 	else if(type == 38)
	{
		SetPlayerAttachedObject ( playerid, 1, setobject, 2, 0.086999,0.055000,0.000000,0.000000,87.600013,95.100013,1.364001,1.279000,1.221999);
	}
 	else if(type == 39)
	{
		SetPlayerAttachedObject ( playerid, 9, setobject, 5, 0.114000,0.040999,-0.044999,93.100112,-12.099985,-75.899986,0.871000,0.899000,0.601999);
	}
 	else if(type == 40)
	{
		SetPlayerAttachedObject ( playerid, 1, setobject, 2, 0.071999,0.011999,0.000000,70.600021,86.500000,17.000003,1.160001,0.993000,1.000000);
	}
 	else if(type == 41)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.096999,0.049999,0.001000,87.099960,84.799987,0.299999,1.000000,1.000000,1.000000);
	}
 	else if(type == 42)
	{
		SetPlayerAttachedObject ( playerid, 1, setobject, 2, 0.096999,0.049999,0.001000,87.099960,84.799987,0.299999,1.000000,1.000000,1.000000);
	}
 	else if(type == 43)
	{
		SetPlayerAttachedObject ( playerid, 1, setobject, 2, 0.096999,0.049999,0.001000,87.099960,84.799987,0.299999,1.000000,1.000000,1.000000);
	}
 	else if(type == 44)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.134000,0.024000,0.001999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 45)
	{
		SetPlayerAttachedObject ( playerid, 1, setobject, 2, 0.101000,0.036999,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 46)
	{
		SetPlayerAttachedObject ( playerid, 1, setobject, 2, 0.164000,0.017000,-0.001000,-11.200000,0.000000,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 47)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.041999,0.069000,0.006999,177.299987,88.100006,0.000000,1.133999,1.390000,0.999999);
	}
 	else if(type == 48)
	{
		SetPlayerAttachedObject ( playerid, 1, setobject, 17, 0.014999,0.082999,-0.003000,32.100006,6.800001,-2.900001,0.540998,1.822000,1.577999);
	}
 	else if(type == 49)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.355999,-0.151999,0.133000,0.000000,-123.899948,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 50)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.167999,-0.173999,-0.059999,-1.299999,55.800003,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 51)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.095999,-0.156000,-0.075999,0.999999,-123.899971,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 52)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.371000,-0.134999,-0.074999,6.599999,65.300010,0.000000,1.000000,1.000000,1.000000);
	}
 	else if(type == 53)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.267999,-0.095999,-0.191000,15.499994,70.300010,163.799911,1.000000,1.000000,1.000000);
	}
 	else if(type == 54)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.294999,-0.131000,-0.026000,7.099997,62.899997,-2.599999,1.000000,1.000000,1.000000);
	}
 	else if(type == 55)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.15, -0.05, 0.18, 90, 0, 270);
	}
 	else if(type == 56)
	{
		SetPlayerAttachedObject ( playerid, 2, setobject, 2, 0.161000,0.013999,-0.000999,86.099945,81.700019,3.600003,1.000000,1.000000,1.000000);
	}
 	else if(type == 57)
	{
		SetPlayerAttachedObject ( playerid, 9, setobject, 18, 0.136999,-0.046000,0.006000,95.599845,-35.199943,9.800123,1.000000,1.000000,1.000000);
	}
 	else if(type == 58)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, -0.054999,-0.223000,-0.064999,-1.799997,21.900007,1.500001,0.814000,0.830000,0.783000);
	}
	else if(type == 60)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.000000, -0.174999, 0.000000, -10.500010, 102.599945, 9.400003, 0.690999, 0.739000, 0.796000);
	}
	else if(type == 61)
	{
		SetPlayerAttachedObject ( playerid, 0, setobject, 2, 0.072999,0.087000,0.000000,0.000000,90.000000,180.000000,0.337000,0.653000,0.466001);
	}
	else if(type == 62)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.095999,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	}
	else if(type == 63)
	{
		SetPlayerAttachedObject ( playerid, 2, setobject, 2, 0.2020, 0.0049,0.0020,0.6000,88.1000,-4.9999,1.0000,1.0000,1.0000,0,0);
	}
	else if(type == 64)
	{
		SetPlayerAttachedObject ( playerid, 0, setobject, 2, 0.075999,-0.019000,0.015000,-72.099998,68.899971,-68.199996,0.153000,0.163000,0.067000);
	}
	else if(type == 65)
	{
		SetPlayerAttachedObject ( playerid, 2, setobject, 2, 0.1189,0.0080,0.0000,0.0000,0.0000,0.0000,1.0000,0.9879,1.0570,0,0);
	}
	else if(type == 66)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.0109,-0.1409,-0.1140,-99.5999,7.8999,58.6999,0.8169,1.2680,0.7229,0,0);
	}
	else if(type == 67)
	{
		SetPlayerAttachedObject ( playerid, 2, setobject, 2, 0.1070,0.0149,0.0000,0.0000,0.0000,0.0000,1.0540,1.0720,0.9779, 0, 0);
	}
	else if(type == 68)
	{
		SetPlayerAttachedObject ( playerid, 9, setobject, 5, 0.2379,-0.0059,0.0110,51.1999,-105.3998,129.9993,0.1459,0.8340,1.0000,0,0);
	}
	else if(type == 69)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1809,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,1.0000,1.0000,0,0);
	}
	else if(type == 70)
	{
		SetPlayerAttachedObject ( playerid, 2, setobject, 2, 0.122000,-0.008000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	}
	else if(type == 71)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0869,-0.0070,0.0010,-4.9999,-2.5999,-101.7999,0.5939,0.6319,0.3300,0,0);
	}
	else if(type == 72)
	{
		SetPlayerAttachedObject ( playerid, 2, setobject, 2, 0.073999,0.072000,0.004999,173.200027,5.599996,89.399955,1.434000,1.130001,1.609000);
	}
	else if(type == 73)
	{
	    SetPlayerAttachedObject ( playerid, 5, setobject, 1, 0.1749, -0.1850, 0.0000, 141.3001, 106.9998, 52.2000, 0.3339, 0.2929, 0.6880, 0, 0);
	}
	else if(type == 74)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 15, 0.162000, -0.027000, 0.033000, 0.000000, 0.000000, 0.000000,  0.009999, 0.009999, 0.009999);
	}
	else if(type == 75)
	{
	    SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.009000, -0.126000, -0.050000, 31.499847, -88.900085, 25.199985, 0.083999, 0.014000, 0.133999, 0, 0);
	}
	else if(type == 76)
	{
	    SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.189999, -0.185999, -0.035999, 82.199905, 16.000019, 70.899978, 0.205999, 0.401000, 0.319999, 0, 0);
	}
	else if(type == 77)
	{
	    SetPlayerAttachedObject ( playerid, 6, setobject, 17, -0.037000, 0.164999, 0.011000, 94.200027,63.199962, 1.599997, 1.000000, 0.570000, 0.601000, 0, 0);
	}
	else if(type == 78)
	{
		SetPlayerAttachedObject ( playerid, 9, setobject, 2, 0.229000, -0.004000, -0.003999, -21.199993, 89.700027, -79.400001, 0.269000, 0.261999, 0.000000);
	}
	else if(type == 79)
	{
		SetPlayerAttachedObject ( playerid, 9, setobject, 2, 0.072999, 0.087000, 0.000000, 0.000000, 90.000000, 180.000000, 0.337000, 0.653000, 0.466001);
	}
	else if(type == 80)
	{
		if ( setobject == 19904 ) SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.041999, 0.069000, 0.006999, 177.299987, 88.100006, 0.000000, 1.133999, 1.390000, 0.999999);
  		else if ( setobject == 19142 ) SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.08, 0.04, 0.00, 0.0, 0.0, -7.4);
	}
	else if(type == 81)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0899, -0.0799, -0.0099, -24.9500, 74.6499, 192.0000, 1.0500, 1.0500, 1.0500);
	}
	else if(type == 82)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0399, -0.0799, 0.0000, 0.0000, 0.0000, 0.0000, 1.1000, 1.1000, 1.1000);
	}
	else if(type == 83)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0199, 0.0599, -0.0099, 95.0000, 75.0000, 78.0000, 1.2000, 1.2000, 1.2000);
	}
	else if(type == 84)
	{
		SetPlayerAttachedObject ( playerid, 7, setobject, 5, 0.0000, -0.0299, -0.0099, 75.0000, 0.0000, 1.0000, 1.3500, 1.3500, 1.3500 ) ;
	}
	else if(type == 85)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.0699, 0.0599, -0.0999, 183.0000, 106.4000, 0.0000, 1.5500, 1.5500, 1.5500);
	}
	else if(type == 86)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1399, 0.0399, 0.0000, 200.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.0000);
	}
	else if(type == 87)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.1599, -0.0199, 0.0099, 0.0000, 90.0500, 0.0000, 0.9000, 0.9000, 0.9000);
	}
	else if(type == 88)
	{
		SetPlayerAttachedObject ( playerid, 7, setobject, 5, 0.0000, 0.0000, 0.0000, 0.0000, -75.0000, -77.0000, 1.5000, 1.5000, 1.5000);
	}
	else if(type == 89)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.2100, 0.0399, -0.0399, 151.0000, 99.9499, 50.0000, 0.9500, 0.9500, 0.9500);
	}
	else if(type == 90)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1499, 0.0500, 0.0500, 0.0000, 0.0000, 168.5000, 0.9500, 0.9500, 0.9500);
	}
	else if(type == 91)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1299, -0.0799, -0.0199, 10.0000, 95.2500, 75.0000, 1.0500, 1.0500, 1.0500);
	}
	else if(type == 92)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0799, -0.1000, 0.0000, 0.0000, 90.0000, 175.0000, 1.2000, 1.2000, 1.2000);
	}
	else if(type == 93)
	{
		SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.1099, 0.0500, 0.0000, 4.5999, 0.0000, 0.0000, 1.3500, 1.3500, 1.3500);
	}
	else if(type == 94)
	{
		SetPlayerAttachedObject ( playerid, 7, setobject, 5, -0.0199, -0.0099, 0.0000, 75.0000, -75.0000, 102.0000, 0.5000, 0.5000, 0.5000);
	}
	else if(type == 95)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1800, 0.0500, 0.0000, 5.1999, 0.0000, 0.0000, 1.1000, 1.1000, 1.1000);
	}
	else if(type == 96)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0999, -0.1299, 0.0000, 175.0000, 90.0000, 0.0000, 1.2000, 1.2000, 1.2000);
	}
	else if(type == 97)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, -0.5900, 0.2700, -0.0700, 75.6499, 66.5499, 19.4000, 1.1000, 1.1000, 1.1000);
	}
	else if(type == 98)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0899, 0.0000, -0.0099, 265.0000, 5.0000, -90.0000, 1.0000, 1.0000, 1.0000);
	}
	else if(type == 99)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1700, 0.0000, -0.0199, -82.4000, -9.9499, -95.0000, 1.0000, 1.0000, 1.0000);
	}
	else if(type == 100)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0899, 0.0199, 0.0000, -90.0000, 10.0000, -95.0000, 1.0000, 1.0000, 1.0000);
	}
	else if(type == 101)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1099, 0.0099, 0.0099, -90.0000, 35.0000, -94.9499, 1.0000, 1.0000, 1.0000);
	}
	else if(type == 102)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1299, 0.0099, 0.0099, -90.0000, 5.0000, -95.0000, 1.2000, 1.2000, 1.2000);
	}
	else if(type == 103)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, -0.1800, 0.0700, 0.0099, 0.0000, 0.3999, -100.0000, 1.0000, 1.0000, 1.0000);
	}
	else if(type == 104)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, -0.0299, 0.0699, 0.0000, -85.0000, 5.0000, 88.5500, 0.9500, 0.9500, 0.9500);
	}
	else if(type == 105)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0999, 0.0199, 0.0000, -95.0000, 20.0000, -95.0000, 1.0500, 1.0500, 1.0500);
	}
	else if(type == 106)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2100, 0.0299, -0.0099, -95.0000, 5.0500, -90.0000, 1.1000, 1.1000, 1.1000);
	}
	else if(type == 107)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0999, 0.0099, 0.0000, -84.3999, 9.9499, -90.0000, 1.0500, 1.0500, 1.0500);
	}
	else if(type == 108)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0899, 0.0099, -0.0199, -90.0000, 9.9499, 260.0000, 1.0500, 1.0500, 1.0500);
	}
	else if(type == 109)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, -0.0399, 0.0000, -0.0099, 187.5000, 93.9499, -1.0499, 1.0500, 1.0500, 1.0500);
	}
	else if(type == 110)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1099, -0.0999, -0.0099, 179.9499, 90.0000, 4.7500, 1.1500, 1.1500, 1.1500);
	}
	else if(type == 111)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1199, -0.0899, 0.0000, 180.0000, 90.0000, 0.0000, 1.1000, 1.1000, 1.1000);
	}
	else if(type == 112)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1299, -0.0999, 0.0000, 180.0000, 93.0000, 0.0000, 1.1000, 1.1000, 1.1000);
	}
	else if(type == 113)
	{
		SetPlayerAttachedObject ( playerid, 4, setobject, 5, 0.2899, 0.0099, 0.0399, 0.0000, -105.0000, 15.0000, 0.9000, 0.9000, 0.9000);
	}
	else if(type == 114)
	{
		SetPlayerAttachedObject ( playerid, 4, setobject, 5, 0.3499, 0.0000, 0.0000, -15.0000, -90.0000, 0.0000, 1.2500, 1.2500, 1.2500);
	}
	else if(type == 115)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1500, -0.0899, -0.0099, 0.0000, 90.0000, 0.5000, 0.9500, 0.9500, 0.9500);
	}
	else if(type == 116)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0699, -0.1900, -0.0199, 0.0000, 90.0000, 0.0000, 1.6000, 1.6000, 1.6000);
	}
	else if(type == 117)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1399, -0.0799, -0.0099, -180.0000, -268.5999, 0.4499, 1.8500, 1.8500, 1.8500);
	}
	else if(type == 118)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1499, -0.0899, -0.0099, 180.0000, -268.7003, -0.1999, 1.7500, 1.7500, 1.7500);
	}
	else if(type == 119)
	{
		SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1399, -0.0799, 0.0000, -180.0000, 90.0500, -0.0499, 1.8000, 1.8000, 1.8000);
	}
	else if(type == 120)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0499, 0.0799, 0.0000, 72.7499, -290.7999, 114.9499, 0.9000, 0.9000, 0.9000);
	}
	else if(type == 121)
	{
		SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0899, 0.0899, -0.0099, 174.9499, 95.0000, 0.0000, 1.1500, 1.1500, 1.1500);
	}
	else if(type == 122)
	{
		SetPlayerAttachedObject ( playerid, 7, setobject, 2, 0.0599, 0.0099, 0.0000, 185.3999, -268.5004, -5.0000, 1.0000, 1.0000, 1.0000);
	}
	else if(type == 147)
	{
		switch ( setobject )
		{
			case 11755: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1279, 0.0419, 0.0010, 1.0000, 88.5999, 179.3999, 1.0000, 1.0000, 1.0000);
			case 11756: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1369, 0.0210, 0.0000, 1.0000, 90.7999, 174.7999, 1.0000, 1.0000, 1.0000);
			case 11757: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0940, 0.0589, 0.0000, 1.0000, 88.7000, -175.6999, 1.1209, 1.1340, 1.0380);
			case 11758: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1190, 0.0589, 0.0019, 1.4000, 85.5999, -178.1000, 1.1579, 1.1959, 1.0679);
			case 11759: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0949, 0.0500, 0.0000, 1.0000, 88.0999, -177.0999, 1.2349, 1.2329, 1.0460);
			case 11760: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1949, 0.0499, 0.0000, 90.8000, 99.4999, 1.0000, 1.1079, 1.0550, 1.0000);
			case 11761: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0959, 0.1400, 0.0000, 1.0000, 94.2999, -176.5000, 1.0000, 1.0000, 1.0000000);
			case 11765: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0839, 0.0430, -0.0089, 1.0000, 76.5000, -167.0000, 0.6279, 0.6819, 0.7310);
			case 11767: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0000, 0.0290, -0.0009, 1.0000, 91.5000, 178.1999, 1.0000, 1.0000, 1.0000);
			case 11768: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0859, 0.0229, 0.0000, 1.0000, 84.9000, 174.5999, 1.5399, 1.7009, 1.8079);
			case 11769: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0429, 0.1219, 0.0039, 92.6998, -166.3000, 88.8002, 1.0000, 1.0000, 1.0000);
			case 11770: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0729, 0.0300, 0.0000, 1.0000, 84.7999, -179.6000, 0.7639, 0.6639, 0.8999);
			case 11771: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0980, 0.0390, -0.0019, 1.0000, 87.0999, -175.7999, 1.1479, 1.0950, 1.1589);
			case 14050..14055: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2200, 0.0000, 0.0000, 1.0000, 1.0000, 14.6999, 1.0000, 1.0000, 1.0000);
			case 14056..14062: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2340, 0.0050, -0.0049, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000);
			case 14073, 14094, 14133, 14134: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1030, 0.0240, 0.0000, 1.0000, 89.6999, -176.5001, 1.0000, 1.0000, 1.0000);
			case 14074..14078: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2170, 0.0160, -0.0090, 1.0000, 93.4000, -175.5000, 1.0000, 1.0000, 1.0000);
			case 14079..14083: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2050, 0.0140, 0.0000, 1.0000, 89.1999, -174.3000, 1.0000, 1.0000, 1.0000);
			case 14084..14088: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1520, 0.0219, 0.0000, 1.0000, 87.7999, -174.7000, 1.0000, 1.0000, 1.0000);
			case 14089..14093: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2190, 0.0200, 0.0000, 1.0000, 90.9999, 174.5000, 1.0000, 1.0000, 1.0000);
			case 14150..14154: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2440, 0.0260, 0.0000, 1.0000, 90.4000, 0.3999, 1.0000, 1.0000, 1.0000);
			case 14155..14159: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1919, 0.0080, 0.0000, 1.0000, 84.1999, -177.1000, 1.0000, 1.0000, 1.0000);
			case 14160..14164: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.3589, 0.0300, 0.0000, 1.0000, 95.8000, -166.4000, 1.0000, 1.0000, 1.0000);
			case 14165..14169: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2049, -0.0250, 0.0000, 1.0000, 87.7999, -178.1999, 1.0000, 1.0000, 1.0000);
		}
	}
	else if(type == 148)
	{
		switch ( setobject )
		{
			case 11763: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1849, -0.1389, 0.0000, 2.1000, 86.9997, -2.4999, 1.0000, 1.0000, 1.0000);
			case 11764: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1389, -0.0409, -0.0240, 1.0000, 88.9999, -179.2000, 1.0000, 1.0000, 1.0000);
			case 11773..11779: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1089, 0.0759, -0.0160, -178.2999, 34.5000, 1.0000, 1.2730, 1.0500, 1.0609);
			case 14063..14068: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2349, 0.0269, -0.0150, 1.0000, 96.6000, -174.0000, 1.1920, 1.1569, 1.0000);
			case 14069..14072: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.3400, 0.0599, -0.0039, 0.2999, 92.9000, -179.8000, 1.0000, 1.0000, 1.0000);
			case 14135..14139: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1390, 0.0440, 0.0000, 1.0000, 92.4000, -164.8999, 1.2709, 1.2269, 1.0000);
			case 14140..14144: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2320, 0.0789, -0.0120, 1.0000, 87.7999, -171.5998, 1.0000, 1.1430, 1.0920);
			case 14145..14148: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1259, -0.1480, -0.0230, 1.0000, 89.9999, -175.8000, 1.0000, 1.1559, 1.1300);
		}
	}
	else if(type == 149)
	{
		switch ( setobject )
		{
			case 11781: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0870, 0.0549, 0.0000, 92.0000, -6.7000, 93.3999, 1.0000, 1.0000, 1.1559);
			case 11782: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0559, 0.0849, -0.0130, -84.4000, -179.2002, -88.5999, 1.0209, 1.0000, 1.0159);
			case 11783: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0449, 0.0510, -0.0150, 84.7999, 2.2000, 89.0999, 1.0000, 1.0000, 1.0000);
		}
	}
	else if(type == 150)
	{
		switch ( setobject )
		{
			case 11762: SetPlayerAttachedObject ( playerid, 8, setobject, 4, -0.1500, -0.0500, 0.0000, -125.0000, 0.0000, -80.5000, 0.4500, 0.4500, 0.4500);
			case 11766: SetPlayerAttachedObject ( playerid, 8, setobject, 4, -0.1500, -0.0500, 0.0000, -125.0000, 0.0000, -80.5000, 0.4500, 0.4500, 0.4500);
			case 11780: SetPlayerAttachedObject ( playerid, 8, setobject, 4, -0.1180, -0.0540, 0.0000, 1.0000, -75.0001, 20.2000, 0.4479, 0.4910, 0.3990);
		}
	}
	else if ( type == 151 )
	{
		switch ( setobject )
		{
			case 12105: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1779, -0.1139, 0.0000, -82.0000, 90.0000, 90.0000, 1.0899, 1.0899, 1.0899 ) ;
			case 12106: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1779, -0.1139, 0.0000, -82.0000, 90.0000, 90.0000, 1.0899, 1.0899, 1.0899 ) ;
			case 12107: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1779, -0.1139, 0.0000, -82.0000, 90.0000, 90.0000, 1.0899, 1.0899, 1.0899 ) ;
			case 12108: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1779, -0.1139, 0.0000, -82.0000, 90.0000, 90.0000, 1.0899, 1.0899, 1.0899 ) ;
			case 12112: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.0899, 0.0180, -85.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12113: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.0899, 0.0180, -85.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12114: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.0899, 0.0180, -85.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12135: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1299, -0.0599, 0.0000, -82.0000, 90.0000, 90.0000, 0.8319, 0.8319, 0.8319 ) ;
			case 12136: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1299, -0.0599, 0.0000, -82.0000, 90.0000, 90.0000, 0.8319, 0.8319, 0.8319 ) ;
			case 12138: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1358, -0.0899, 0.0178, -170.0000, 86.0000, 80.0000, 1.0359, 1.0359, 1.0359 ) ;
			case 12140: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.0039, -0.2098, -0.0061, 4.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12152: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.0899, 0.0180, -85.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12153: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12154: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12155: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12160: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			
			case 12109: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1599, 0.0539, 0.0000, 88.0000, 185.0000, 90.0000, 1.0960, 1.0960, 1.0960 ) ;
			case 12110: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1599, 0.0539, 0.0000, 88.0000, 185.0000, 90.0000, 1.0960, 1.0960, 1.0960 ) ;
			case 12111: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1599, 0.0539, 0.0000, 88.0000, 185.0000, 90.0000, 1.0960, 1.0960, 1.0960 ) ;
			case 12115: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12116: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12117: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12118: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12119: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12120: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12121: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12122: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12123: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12124: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12125: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12126: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12127: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12128: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12129: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12130: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12131: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12132: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12133: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12134: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1000, 0.0539, 0.0000, 101.0000, 90.0000, 90.0000, 1.2820, 1.2820, 1.2820 ) ;
			case 12137: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.3099, 0.0300, 0.0058, -85.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12142: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1418, 0.0420, 0.0178, -85.0000, 86.0000, 175.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12144: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.0999, 0.1320, -0.0061, -85.0000, 100.0000, 168.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12145: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1718, 0.0060, -0.0121, -85.0000, 86.0000, 38.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12148: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.3339, 0.0300, 0.0178, -85.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12149: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.1958, 0.0661, 0.0178, -85.0000, 86.0000, 174.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12150: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2258, 0.0480, 0.0178, -85.0000, 86.0000, 167.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12151: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2258, 0.0120, 0.0058, -85.0000, 86.0000, 164.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12156: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12158: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12159: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12161: SetPlayerAttachedObject ( playerid, 5, setobject, 2, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			
			case 12100: SetPlayerAttachedObject ( playerid, 7, setobject, 5, 0.1779, 0.0240, 0.0300, 102.0000, -2.0000, 95.0000, 0.0219, 0.0219, 0.0219 ) ;
			case 12101: SetPlayerAttachedObject ( playerid, 7, setobject, 5, 0.2378, 0.0180, 0.0300, 103.0000, -2.0000, 90.0000, 0.0219, 0.0219, 0.0219 ) ;
			case 12102: SetPlayerAttachedObject ( playerid, 7, setobject, 5, 0.2198, -0.0119, 0.0240, -268.0000, -10.0000, 90.0000, 0.0219, 0.0219, 0.0219 ) ;
			case 12103: SetPlayerAttachedObject ( playerid, 7, setobject, 5, 0.3398, -0.0478, 0.0060, -82.0000, -75.0000, 90.0000, 1.6119, 1.6119, 1.6119 ) ;
			case 12104: SetPlayerAttachedObject ( playerid, 7, setobject, 5, 0.3398, -0.0478, 0.0060, -82.0000, -75.0000, -5.0000, 1.6117, 1.6117, 1.6117 ) ;
			


			case 12139: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1658, -0.0899, 0.0178, -186.0000, 126.0000, 101.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12143: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1059, 0.0000, -0.1860, 8.0000, 178.0000, -98.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12146: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1598, -0.1858, -0.0181, -92.0000, 86.0000, 184.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12147: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2258, -0.0899, 0.0178, -85.0000, 86.0000, 80.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12157: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12162: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12163: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12164: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12165: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12166: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12167: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12168: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12169: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.2919, -0.1138, 0.0178, -85.0000, 86.0000, -9.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12170: SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.17, 0.00, -0.02, -262.00, 86.00, -9.00, 0.99, 0.99, 0.99 ) ;
			case 12171: SetPlayerAttachedObject ( playerid, 6, setobject, 1, -0.17, 0.00, -0.02, -262.00, 86.00, -9.00, 0.99, 0.99, 0.99 ) ;
			case 12172: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1418, 0.0420, 0.0178, -85.0000, 86.0000, 175.0000, 0.9939, 0.9939, 0.9939 ) ;
			case 12173: SetPlayerAttachedObject ( playerid, 6, setobject, 1, 0.1418, 0.0420, 0.0178, -85.0000, 86.0000, 175.0000, 0.9939, 0.9939, 0.9939 ) ;
		}
	}
	return true ;
}