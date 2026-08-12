stock cont_OnGameModeInit()
{
    Create3DTextLabel(""colwhi"Контейнер "colserver"№1\n\n"colwhi"Класс: "colserver"Бронзовый\n"colwhi"Стоимость: "colserver"250.000$\n\n"colwhi"Используйте "colserver"H"colwhi", для взаимодействия", COLOR_WHITE, 1017.33, -1964.05, 13.18, 10.0, 0, 1);
	Create3DTextLabel(""colwhi"Контейнер "colserver"№2\n\n"colwhi"Класс: "colserver"Серебряный\n"colwhi"Стоимость: "colserver"2.000.000$\n\n"colwhi"Используйте "colserver"H"colwhi", для взаимодействия", COLOR_WHITE, 1017.33, -1958.05, 13.18, 10.0, 0, 1);
	Create3DTextLabel(""colwhi"Контейнер "colserver"№3\n\n"colwhi"Класс: "colserver"Золотой\n"colwhi"Стоимость: "colserver"5.000.000$\n\n"colwhi"Используйте "colserver"H"colwhi", для взаимодействия", COLOR_WHITE, 1017.33, -1952.05, 13.18, 10.0, 0, 1);
	Create3DTextLabel("« {FF3F3F}Пустой контейнер {FFFFFF}»", COLOR_WHITE, 1017.33, -1946.05, 13.18, 5.0, 0, 1);

	CreateDynamicPickup(1274, 23, 1017.33, -1964.05, 13.18);
	CreateDynamicPickup(1274, 23, 1017.33, -1958.05, 13.18);
	CreateDynamicPickup(1274, 23, 1017.33, -1952.05, 13.18);

	new kontrs;
	kontrs = CreateDynamicObject(984, 1037.396240, -1965.836914, 12.511774, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 3, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 4, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 5, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 7, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 8, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 9, 18878, "ferriswheel", "railing3", 0xFFFFFFFF);
	kontrs = CreateDynamicObject(984, 1038.053100, -1942.323608, 12.511770, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 3, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 4, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 5, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 7, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 8, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 9, 18878, "ferriswheel", "railing3", 0xFFFFFFFF);
	kontrs = CreateDynamicObject(19791, 1033.136596, -1940.531738, 12.101092, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(984, 1037.965942, -1945.515258, 12.511760, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 3, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 4, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 5, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 7, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 8, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 9, 18878, "ferriswheel", "railing3", 0xFFFFFFFF);
	kontrs = CreateDynamicObject(9339, 1025.226074, -1935.427734, 12.464823, -0.000009, 0.000000, -91.599853, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 630, "gta_potplants", "greekurn", 0x00000000);
	kontrs = CreateDynamicObject(9339, 1021.327209, -1935.320678, 12.462817, -0.000009, 0.000000, -91.599853, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 630, "gta_potplants", "greekurn", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1023.140625, -1940.252563, 12.101080, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1023.121704, -1940.241943, 11.761075, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 10755, "airportrminl_sfse", "ws_airportconc1", 0x00000000);
	kontrs = CreateDynamicObject(19740, 1027.558715, -1944.459960, 6.271055, 0.000000, 270.000000, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3906, "libertyhi5", "walldirtynewa256128", 0x00000000);
	kontrs = CreateDynamicObject(760, 1026.869995, -1944.362915, 12.261077, 0.000000, 0.000029, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 825, "gta_proc_bigbush", "veg_bush4", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 825, "gta_proc_bigbush", "veg_bush1", 0x00000000);
	kontrs = CreateDynamicObject(13646, 1026.865722, -1944.440673, 11.591076, 0.000000, 0.000029, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 5704, "melrose07_lawn", "ws_conc_step1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 5462, "glenpark6_lae", "dirty256", 0x00000000);
	kontrs = CreateDynamicObject(19740, 1026.184814, -1944.421752, 6.271059, 0.000000, 90.000030, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3906, "libertyhi5", "walldirtynewa256128", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1032.857788, -1950.527832, 12.101084, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.936401, -1942.922485, 13.693101, 0.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFFFA5FF);
	kontrs = CreateDynamicObject(19791, 1013.144531, -1939.973388, 12.101084, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(3785, 1017.751342, -1944.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(957, 1017.751342, -1944.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1013.067321, -1942.411865, 11.761075, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 10755, "airportrminl_sfse", "ws_airportconc1", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1022.861389, -1950.248657, 12.101092, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(957, 1017.751220, -1947.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(3785, 1017.751220, -1947.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(19321, 1013.419006, -1946.053344, 13.643097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3621, "dockcargo1_las", "sjmpostback", 0xFFFFA5FF);
	SetDynamicObjectMaterial(kontrs, 1, 3564, "dockcargo2_las", "lastrk5", 0xFFFFA5FF);
	kontrs = CreateDynamicObject(11292, 1013.410827, -1946.343627, 10.593070, 0.000006, 0.000023, -0.000059, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 3621, "dockcargo1_las", "lasdkcrtgr11", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 18029, "genintintsmallrest", "GB_restaursmll03", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.937011, -1949.148071, 13.583103, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFFFA5FF);
	kontrs = CreateDynamicObject(957, 1017.751342, -1950.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(3785, 1017.751342, -1950.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.936401, -1950.472534, 13.693101, 0.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFFFD700);
	kontrs = CreateDynamicObject(19791, 1032.578369, -1960.523925, 12.101094, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1012.865295, -1949.969604, 12.101094, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1012.845581, -1949.990234, 11.761075, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 10755, "airportrminl_sfse", "ws_airportconc1", 0x00000000);
	kontrs = CreateDynamicObject(3785, 1017.751220, -1953.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(957, 1017.751220, -1953.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.937011, -1953.598022, 13.583103, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFFFD700);
	kontrs = CreateDynamicObject(9339, 1008.045043, -1947.888671, 12.464818, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 630, "gta_potplants", "greekurn", 0x00000000);
	kontrs = CreateDynamicObject(19321, 1013.419006, -1952.053344, 13.643097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3621, "dockcargo1_las", "sjmpostback", 0xFFFFD700);
	SetDynamicObjectMaterial(kontrs, 1, 3564, "dockcargo2_las", "lastrk5", 0xFFFFD700);
	kontrs = CreateDynamicObject(11292, 1013.410827, -1952.343627, 10.593070, 0.000006, 0.000023, -0.000059, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 3621, "dockcargo1_las", "lasdkcrtgr11", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 18029, "genintintsmallrest", "GB_restaursmll03", 0x00000000);
	kontrs = CreateDynamicObject(3785, 1017.751342, -1956.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(957, 1017.751342, -1956.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.936401, -1956.472534, 13.693101, 0.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFC0C0C0);
	kontrs = CreateDynamicObject(19791, 1022.582275, -1960.244750, 12.101084, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(3785, 1017.751220, -1959.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(957, 1017.751220, -1959.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.937011, -1959.598022, 13.583103, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFC0C0C0);
	kontrs = CreateDynamicObject(19321, 1013.419006, -1958.053344, 13.643097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3621, "dockcargo1_las", "sjmpostback", 0xFFC0C0C0);
	SetDynamicObjectMaterial(kontrs, 1, 3564, "dockcargo2_las", "lastrk5", 0xFFC0C0C0);
	kontrs = CreateDynamicObject(11292, 1013.410827, -1958.343627, 10.593070, 0.000006, 0.000023, -0.000059, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 3621, "dockcargo1_las", "lasdkcrtgr11", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 18029, "genintintsmallrest", "GB_restaursmll03", 0x00000000);
	kontrs = CreateDynamicObject(984, 1037.307250, -1969.026000, 12.511774, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 3, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 4, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 5, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 7, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 8, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 9, 18878, "ferriswheel", "railing3", 0xFFFFFFFF);
	kontrs = CreateDynamicObject(3785, 1017.751342, -1962.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(957, 1017.751342, -1962.128295, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(760, 1026.869995, -1966.362915, 12.261077, 0.000000, 0.000029, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 825, "gta_proc_bigbush", "veg_bush4", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 825, "gta_proc_bigbush", "veg_bush1", 0x00000000);
	kontrs = CreateDynamicObject(19740, 1027.558715, -1966.459960, 6.271055, 0.000000, 270.000000, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3906, "libertyhi5", "walldirtynewa256128", 0x00000000);
	kontrs = CreateDynamicObject(13646, 1026.865722, -1966.440673, 11.591076, 0.000000, 0.000029, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 5704, "melrose07_lawn", "ws_conc_step1", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 1, 5462, "glenpark6_lae", "dirty256", 0x00000000);
	kontrs = CreateDynamicObject(19740, 1026.184814, -1966.421752, 6.271059, 0.000000, 90.000030, -1.600003, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3906, "libertyhi5", "walldirtynewa256128", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1012.586181, -1959.965698, 12.101085, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1012.566101, -1959.985351, 11.761075, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 10755, "airportrminl_sfse", "ws_airportconc1", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.936401, -1962.472534, 13.693101, 0.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFCD7F32);
	kontrs = CreateDynamicObject(19791, 1032.298950, -1970.520019, 12.101091, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(3785, 1017.751220, -1965.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	kontrs = CreateDynamicObject(957, 1017.751220, -1965.930541, 12.191087, 0.000023, 180.000000, 89.999763, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 18757, "vcinteriors", "metalplate9", 0x00000000);
	kontrs = CreateDynamicObject(3062, 1016.937011, -1965.598022, 13.583103, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3564, "dockcargo2_las", "lastrk5", 0xFFCD7F32);
	kontrs = CreateDynamicObject(19321, 1013.419006, -1964.053344, 13.643097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 3621, "dockcargo1_las", "sjmpostback", 0xFFCD7F32);
	SetDynamicObjectMaterial(kontrs, 1, 3564, "dockcargo2_las", "lastrk5", 0xFFCD7F32);
	kontrs = CreateDynamicObject(11292, 1013.410827, -1964.343627, 10.593070, 0.000006, 0.000023, -0.000059, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 1, 3621, "dockcargo1_las", "lasdkcrtgr11", 0x00000000);
	SetDynamicObjectMaterial(kontrs, 6, 18029, "genintintsmallrest", "GB_restaursmll03", 0x00000000);
	kontrs = CreateDynamicObject(9339, 1007.655151, -1961.776123, 12.466826, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 630, "gta_potplants", "greekurn", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1022.302917, -1970.240844, 12.101092, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(19791, 1012.306823, -1969.961669, 12.101082, 0.000000, 180.000000, -1.600005, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 4562, "plaza1_lan2", "sl_blokpave1", 0x00000000);
	kontrs = CreateDynamicObject(9339, 1024.115600, -1975.177978, 12.464821, -0.000017, 0.000000, -91.599853, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 630, "gta_potplants", "greekurn", 0x00000000);
	kontrs = CreateDynamicObject(9339, 1020.217163, -1975.065063, 12.462817, -0.000017, 0.000000, -91.599853, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontrs, 0, 630, "gta_potplants", "greekurn", 0x00000000);
	kontrs = CreateDynamicObject(792, 1034.504272, -1939.473999, 12.271085, 0.000000, 0.000014, -1.600005, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(737, 1026.865722, -1944.440673, 12.211071, 0.000000, 0.000029, -1.600003, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(19121, 1037.646484, -1952.258300, 12.622982, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(19121, 1037.550903, -1955.677001, 12.622987, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(1231, 1015.164367, -1943.083862, 14.811098, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(19121, 1037.455200, -1959.095458, 12.622982, 0.000000, 0.000007, -1.600005, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(1231, 1015.164367, -1955.082885, 14.811098, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(737, 1026.865722, -1966.440673, 12.211071, 0.000000, 0.000029, -1.600003, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(792, 1033.604125, -1971.641845, 12.271084, 0.000000, 0.000014, -1.600005, -1, -1, -1, 300.00, 300.00);
	kontrs = CreateDynamicObject(1231, 1015.164367, -1967.073974, 14.811098, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	return 1;
}
stock cont_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == 262144)
    {
		if(IsPlayerInRangeOfPoint(playerid, 3, 1017.33, -1964.05, 13.18))
		{
			ShowPlayerDialog(playerid, D_CONT_1, 0, ""colserver"Покупка контейнера",
			""colwhi"В контейнере бронзового класса может выпасть любой приз из ниже перечисленных\
			\n\t"colserver"—"colwhi" EXP\
			\n\t"colserver"—"colwhi" 250.000$\
			\n\t"colserver"—"colwhi" 500.000$\
			\n\t"colserver"—"colwhi" 1.000.000$\
			\n\n"colserver"Вы"colwhi" действительно желаете приобрести контейнер данного класса?", "Купить", "Закрыть");
		}
		if(IsPlayerInRangeOfPoint(playerid, 3, 1017.33, -1958.05, 13.18))
		{
			ShowPlayerDialog(playerid, D_CONT_2, 0, ""colserver"Покупка контейнера",
			""colwhi"В контейнере серебряного класса может выпасть любой приз из ниже перечисленных\
			\n\t"colserver"—"colwhi" Euro\
			\n\t"colserver"—"colwhi" 2.000.000$\
			\n\t"colserver"—"colwhi" 2.500.000$\
			\n\t"colserver"—"colwhi" 4.000.000$\
			\n\n"colserver"Вы"colwhi" действительно желаете приобрести контейнер данного класса?", "Купить", "Закрыть");
		}
		if(IsPlayerInRangeOfPoint(playerid, 3, 1017.33, -1952.05, 13.18))
		{
			ShowPlayerDialog(playerid, D_CONT_3, 0, ""colserver"Покупка контейнера",
			""colwhi"В контейнере золотого класса может выпасть любой приз из ниже перечисленных\
			\n\t"colserver"—"colwhi" Euro\
			\n\t"colserver"—"colwhi" 5.500.000$\
			\n\t"colserver"—"colwhi" 6.000.000$\
			\n\t"colserver"—"colwhi" 10.000.000$\
			\n\n"colserver"Вы"colwhi" действительно желаете приобрести контейнер данного класса?", "Купить", "Закрыть");
		}
		return true;
    }
	return 1;
}