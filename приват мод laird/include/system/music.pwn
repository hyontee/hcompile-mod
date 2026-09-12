

// ==== Ниже вклеено содержимое music_premium_links.inc (объединено в один файл) ====
// ==================================================================================
// music_premium_links.inc
// Ссылки на треки плейлистов NCS (альбомы 6-9 в music.pwn: Фонк, Ночная езда, Экшен,
// Ещё хиты NCS). Все названия — реальные треки лейбла NoCopyrightSounds (ncs.io).
//
// ВАЖНО про лицензию NCS: их бесплатная политика официально покрывает YouTube/Twitch-
// контент независимых авторов. Использование в играх формально требует отдельной
// Commercial License (форма на ncs.io) — для маленького некоммерческого сервера это
// обычно быстро и бесплатно, но шаг отдельный, не просто "скачал и вставил".
//
// Как подключить: скачайте трек с ncs.io (кнопка Free Download на странице трека),
// залейте себе на хостинг (как остальные альбомы — Dropbox с &dl=1 на конце,
// либо свой CDN), вставьте готовую прямую ссылку в format(url, size, "..."); ниже.
//
// playlistid: 0=Фонк, 1=Ночная езда, 2=Экшен, 3=Ещё хиты NCS (соответствует albumid-6
// из music.pwn). trackid: 0-4, порядок как в Music_GetPaidTrackName.
// ==================================================================================

stock Music_GetNewPlaylistTrackUrl(playlistid, trackid, url[], size = sizeof(url))
{
    switch(playlistid)
    {
        case 0: // Фонк (NCS)
        {
            switch(trackid)
            {
                case 0: format(url, size, ""); // MANSHN - Online
                case 1: format(url, size, ""); // Slowboy - Adrenaline
                case 2: format(url, size, ""); // Lost Sky - Hero's Ending
                // слоты 3-4 пока пустые — вы называли только 3 трека для этой категории
            }
        }
        case 1: // Ночная езда (NCS)
        {
            switch(trackid)
            {
                case 0: format(url, size, ""); // Warriyo - Mortals
                case 1: format(url, size, ""); // Unknown Brain - Superhero
                case 2: format(url, size, ""); // Kovan & Electro-Light - Skyline Pt. II
                case 3: format(url, size, ""); // Axol & Alex Skrindo - You
                case 4: format(url, size, ""); // Cartoon - Why We Lose
            }
        }
        case 2: // Экшен (NCS)
        {
            switch(trackid)
            {
                case 0: format(url, size, ""); // Egzod, Maestro Chives, Neoni - Royalty
                case 1: format(url, size, ""); // Electro-Light - Drakkar
                case 2: format(url, size, ""); // Distrion - Alibi
                case 3: format(url, size, ""); // Robin Hustin & TobiMorrow - Light It Up
                case 4: format(url, size, ""); // BEAUZ & JVNA - Crazy
            }
        }
        case 3: // Ещё хиты NCS
        {
            switch(trackid)
            {
                case 0: format(url, size, ""); // DEAF KEV - Invincible
                case 1: format(url, size, ""); // Tobu - Candyland
                case 2: format(url, size, ""); // Different Heaven - Nekozilla
                case 3: format(url, size, ""); // Vexento - Digital Rain
                case 4: format(url, size, ""); // JJD - Adventure
            }
        }
        default: format(url, size, "");
    }
    return 1;
}
// ==== Конец вклеенного содержимого ====

#define GUI_MUSIC_AUDIO                 9 // больше не используется (перешли на обычные диалоги), оставлено на всякий случай

#define DIALOG_MUSIC_MAIN               20101
#define DIALOG_MUSIC_FREE               20102
#define DIALOG_MUSIC_ALBUMS             20103
#define DIALOG_MUSIC_TRACKS             20104
#define DIALOG_MUSIC_BUY                20105
#define MUSIC_PAGE_SIZE                 4
#define MUSIC_ALBUM_PRICE               249
#define MUSIC_ALBUM_COUNT               10
#define MUSIC_FREE_TRACK_COUNT          12
#define MUSIC_PAID_TRACKS_PER_ALBUM     5
#define MUSIC_TAB_FREE                  0
#define MUSIC_TAB_PREMIUM               1
#define MUSIC_BTN_ITEM_0                0
#define MUSIC_BTN_ITEM_1                1
#define MUSIC_BTN_ITEM_2                2
#define MUSIC_BTN_ITEM_3                3
#define MUSIC_BTN_SEARCH                4
#define MUSIC_BTN_NEXT                  5
#define MUSIC_BTN_PREV                  6
#define MUSIC_BTN_BACK                  7
#define MUSIC_BTN_SEARCH_SEND           8
#define SC "{FFFF00}| {FFFFFF}"

new musicOn[MAX_PLAYERS];
new g_music_gui_page[MAX_PLAYERS][2];
new g_music_selected_album[MAX_PLAYERS];
new bool:g_music_premium_tracks[MAX_PLAYERS];
new g_music_active_tab[MAX_PLAYERS];
new g_music_active_name[MAX_PLAYERS][96];
new bool:g_music_active_premium[MAX_PLAYERS];
new bool:g_music_db_inited;

stock Music_InitDatabase()
{
    if(g_music_db_inited) return 1;

    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `music_albums` (`id` INT(11) NOT NULL AUTO_INCREMENT, `uid` INT(11) NOT NULL, `album_id` INT(11) NOT NULL, `created_at` INT(11) NOT NULL DEFAULT 0, PRIMARY KEY (`id`), UNIQUE KEY `uid_album` (`uid`, `album_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;", false);

    g_music_db_inited = true;
    return 1;
}

stock Music_CountPages(total)
{
    if(total <= 0) return 1;
    return (total + MUSIC_PAGE_SIZE - 1) / MUSIC_PAGE_SIZE;
}

stock Music_GetFreeTrackName(trackid, name[], size = sizeof(name))
{
    // Первая вкладка GUI case 9 — «Радиостанция».
    switch(trackid)
    {
        case 0: format(name, size, "Европа Плюс");
        case 1: format(name, size, "Русское Радио");
        case 2: format(name, size, "DFM");
        case 3: format(name, size, "Радио Record");
        case 4: format(name, size, "Авторадио");
        case 5: format(name, size, "Новое Радио");
        case 6: format(name, size, "Радио ENERGY");
        case 7: format(name, size, "Дорожное Радио");
        case 8: format(name, size, "Ретро FM");
        case 9: format(name, size, "Relax FM");
        case 10: format(name, size, "Like FM");
        case 11: format(name, size, "Радио Maximum");
        default: format(name, size, "Радиостанция");
    }
    return 1;
}

stock Music_GetFreeTrackUrl(trackid, url[], size = sizeof(url))
{
    // Прямые stream-ссылки радиостанций. Если станция поменяет поток — меняется только URL здесь.
    switch(trackid)
    {
        case 0: format(url, size, "https://ep256.hostingradio.ru:8052/europaplus256.mp3");
        case 1: format(url, size, "https://rusradio.hostingradio.ru/rusradio96.aacp");
        case 2: format(url, size, "https://dfm.hostingradio.ru/dfm96.aacp");
        case 3: format(url, size, "https://radiorecord.hostingradio.ru/rr_main96.aacp");
        case 4: format(url, size, "https://pub0302.101.ru:8443/stream/air/aac/64/100");
        case 5: format(url, size, "https://icecast-newradio.cdnvideo.ru/newradio3");
        case 6: format(url, size, "https://pub0302.101.ru:8443/stream/air/aac/64/99");
        case 7: format(url, size, "https://dorognoe.hostingradio.ru/radio");
        case 8: format(url, size, "https://retroserver.streamr.ru:8043/retro256.mp3");
        case 9: format(url, size, "https://pub0302.101.ru:8443/stream/pro/aac/64/200");
        case 10: format(url, size, "https://pub0302.101.ru:8443/stream/air/aac/64/219");
        case 11: format(url, size, "https://maximum.hostingradio.ru/maximum96.aacp");
        default: format(url, size, "");
    }
    return 1;
}

stock Music_GetAlbumName(albumid, name[], size = sizeof(name))
{
    // Вторая вкладка GUI case 9 — «Библиотека». Это платные альбомы/плейлисты.
    switch(albumid)
    {
        case 0: format(name, size, "MORGENSHTERN - Альбом");
        case 1: format(name, size, "Miyagi - Альбом");
        case 2: format(name, size, "Miyagi & Andy Panda - Pack");
        case 3: format(name, size, "FONK / Drift Music");
        case 4: format(name, size, "Музыка Хит - Плейлист");
        case 5: format(name, size, "Виктор Цой - Альбом");
        // ДОБАВЛЕНО: новые тематические плейлисты (реальные треки лейбла NCS — NoCopyrightSounds)
        case 6: format(name, size, "Фонк (NCS)");
        case 7: format(name, size, "Ночная езда (NCS)");
        case 8: format(name, size, "Экшен (NCS)");
        case 9: format(name, size, "Ещё хиты NCS");
        default: format(name, size, "Альбом");
    }
    return 1;
}

stock Music_GetPaidTrackName(albumid, trackid, name[], size = sizeof(name))
{
    switch(albumid)
    {
        case 0:
        {
            switch(trackid)
            {
                case 0: format(name, size, "MORGENSHTERN - Cadillac");
                case 1: format(name, size, "MORGENSHTERN - Cristal & МОЁТ");
                case 2: format(name, size, "MORGENSHTERN - Новый Мерин");
                case 3: format(name, size, "MORGENSHTERN - ПОВОД");
                case 4: format(name, size, "MORGENSHTERN - ДОМ");
            }
        }
        case 1:
        {
            switch(trackid)
            {
                case 0: format(name, size, "Miyagi - ТАМАДА");
                case 1: format(name, size, "Miyagi - Нирвана");
                case 2: format(name, size, "Miyagi - Где была мечта заветная");
                case 3: format(name, size, "Miyagi - Я хочу любить");
                case 4: format(name, size, "Miyagi - Руки в облаках");
            }
        }
        case 2:
        {
            switch(trackid)
            {
                case 0: format(name, size, "Miyagi & Andy Panda - Колизей");
                case 1: format(name, size, "Miyagi & Andy Panda - На волне");
                case 2: format(name, size, "Miyagi & Andy Panda - Get Up");
                case 3: format(name, size, "Miyagi & Andy Panda - Бейба судьба");
                case 4: format(name, size, "Miyagi & Andy Panda - I Got Love");
            }
        }
        case 3:
        {
            switch(trackid)
            {
                case 0: format(name, size, "FONK - NO BATIDO");
                case 1: format(name, size, "FONK - MATADORA");
                case 2: format(name, size, "FONK - FUNK ABNORMAL");
                case 3: format(name, size, "FONK - MONTAGEM SANTA FE 2");
                case 4: format(name, size, "FONK - DIPIENS, HRXSTAL - PPAPTEKK");
            }
        }
        case 4:
        {
            switch(trackid)
            {
                case 0: format(name, size, "GAZAN - Черемша");
                case 1: format(name, size, "GAZAN - Six Seven");
                case 2: format(name, size, "9 Грамм - Дэнс");
                case 3: format(name, size, "DEAD BLONDE - Банкомат");
                case 4: format(name, size, "ЧЕЛОВЕК ЯЙЦА - ЗАЛЕТАРИКИ");
            }
        }
        case 5:
        {
            switch(trackid)
            {
                case 0: format(name, size, "Виктор Цой - Спокойной ночи");
                case 1: format(name, size, "Виктор Цой - Хочу перемен");
                case 2: format(name, size, "Виктор Цой - Группа крови");
                case 3: format(name, size, "Виктор Цой - Пачка сигарет");
                case 4: format(name, size, "Виктор Цой - Звезда по имени Солнце");
            }
        }
        // ИСПРАВЛЕНО: треки новых плейлистов (реальные треки лейбла NCS)
        case 6:
        {
            switch(trackid)
            {
                case 0: format(name, size, "MANSHN - Online");
                case 1: format(name, size, "Slowboy - Adrenaline");
                case 2: format(name, size, "Lost Sky - Hero's Ending");
                default: format(name, size, "Скоро добавим ещё");
            }
        }
        case 7:
        {
            switch(trackid)
            {
                case 0: format(name, size, "Warriyo - Mortals");
                case 1: format(name, size, "Unknown Brain - Superhero");
                case 2: format(name, size, "Kovan & Electro-Light - Skyline Pt. II");
                case 3: format(name, size, "Axol & Alex Skrindo - You");
                case 4: format(name, size, "Cartoon - Why We Lose");
            }
        }
        case 8:
        {
            switch(trackid)
            {
                case 0: format(name, size, "Egzod, Maestro Chives, Neoni - Royalty");
                case 1: format(name, size, "Electro-Light - Drakkar");
                case 2: format(name, size, "Distrion - Alibi");
                case 3: format(name, size, "Robin Hustin & TobiMorrow - Light It Up");
                case 4: format(name, size, "BEAUZ & JVNA - Crazy");
            }
        }
        case 9:
        {
            switch(trackid)
            {
                case 0: format(name, size, "DEAF KEV - Invincible");
                case 1: format(name, size, "Tobu - Candyland");
                case 2: format(name, size, "Different Heaven - Nekozilla");
                case 3: format(name, size, "Vexento - Digital Rain");
                case 4: format(name, size, "JJD - Adventure");
            }
        }
        default: format(name, size, "Виктор Цой - Альбом"); // ИСПРАВЛЕНО: default обязан быть последним case в Pawn — раньше стоял перед case 6-9
    }
    return 1;
}

stock Music_GetPaidTrackUrl(albumid, trackid, url[], size = sizeof(url))
{
    // ДОБАВЛЕНО: ссылки новых плейлистов (альбомы 6-9) вынесены в отдельный файл
    // music_premium_links.inc — так их можно обновлять отдельно от всей остальной системы.
    if(albumid >= 6)
        return Music_GetNewPlaylistTrackUrl(albumid - 6, trackid, url, size);

    // URL MAP FOR LIBRARY ALBUM TRACKS.
    // Put/replace direct mp3 or stream links here:
    // albumid = album number from Music_GetAlbumName()
    // trackid = track number from Music_GetPaidTrackName()
    // Example: case 0: format(url, size, "https://your-site.ru/music/album0_track0.mp3");
    switch(albumid)
    {
        case 0:
        {
            switch(trackid)
            {
                case 0: format(url, size, "https://www.dropbox.com/scl/fi/9995zutnp3emkkv70vm3q/MORGENSHTERNfeat_JEldzhi_-_KADILLAK_69853991.mp3?rlkey=5kywtcab0xr489nfz9acgqw35&st=47mhv2vg&dl=1");
                case 1: format(url, size, "https://www.dropbox.com/scl/fi/vjxy41fpkbs9kl3zr4i44/MORGENSHTERN_-_Cristal_MOJOT_72141222.mp3?rlkey=v245oumu9iw14crlldhoh306y&st=a2rrraz1&dl=1");
                case 2: format(url, size, "https://www.dropbox.com/scl/fi/jd1gmqih2twkb4mnb5ttj/MORGENSHTERN_-_Novyjj_Merin_66404393.mp3?rlkey=j4vcgt7x3kq09zseytgp01zo2&st=b3ij874v&dl=1");
                case 3: format(url, size, "https://www.dropbox.com/scl/fi/4do5zbjtq61be9ngtijk4/MORGENSHTERN_-_POVOD_79042608.mp3?rlkey=8eyhkmb4rtc5g21taj173jmmr&st=6b0elkle&dl=1");
                case 4: format(url, size, "https://www.dropbox.com/scl/fi/3vdkg0cuqcuk5wg3bduzg/MORGENSHTERN_-_DOM_London_Praga_Nicca_79042607.mp3?rlkey=iil8b55y8z0qzjpdq9zxl6zop&st=xv5y91y0&dl=1");
            }
        }
        case 1:
        {
            switch(trackid)
            {
                case 0: format(url, size, "https://www.dropbox.com/scl/fi/jq7jyfjwuzw4u1rwayp53/MiyaGi_JEndshpil_al_l_bo_Wooshendoo_-_TAMADA_60831930.mp3?rlkey=t8bfvemydtib3b6u40v87guzl&st=2khe3dxr&dl=1");
                case 1: format(url, size, "https://www.dropbox.com/scl/fi/6zg5avjbejm718us957c4/Miyagi_Fuze_Krec_-_Nirvana_47829537.mp3?rlkey=erycc3ang0zib2ok8s8gnjh4r&st=e2ivuu8y&dl=1");
                case 2: format(url, size, "https://www.dropbox.com/scl/fi/hn70ptayppfgvz2em7ys1/Andy-Panda-Muzparty.net-www.lightaudio.ru.mp3?rlkey=brr367134s8dkhebz5xyu2c9z&st=98y0bn69&dl=1");
                case 3: format(url, size, "https://www.dropbox.com/scl/fi/hgm3mqe8xhq5678x1rlyp/MiyaGi_JEndshpil_-_YA_khochu_lyubit_79898854.mp3?rlkey=au6yg1imvtcqox60g1g5y873n&st=oomelim0&dl=1");
                case 4: format(url, size, "https://www.dropbox.com/scl/fi/4kme0cwes2pqjtiv6kx3j/Vostochnyjj_okrug_Miyagi_JEndshpil_JEndshpil_-_Ruki_v_oblaka_64577525.mp3?rlkey=p94b9qnkxbmx5lwc6e7n8dh6j&st=7m0z3hkt&dl=1");
            }
        }
        case 2:
        {
            switch(trackid)
            {
                case 0: format(url, size, "https://www.dropbox.com/scl/fi/6elfhwa4cy7l0s61x29vu/MiyaGi_JEndshpil_-_Kolizejj_57475559.mp3?rlkey=h5u4r0loamoz73n7lzr3d2w70&st=6heretk5&dl=1");
                case 1: format(url, size, "https://www.dropbox.com/scl/fi/ycvaw4qfqb0d0a2nje9us/muzmo.ru-muzmo.ru-www.lightaudio.ru.mp3?rlkey=f97xllu8k1mww43w8xrg7cni5&st=4z2mg5ny&dl=1");
                case 2: format(url, size, "https://www.dropbox.com/scl/fi/gkdf4wwsxn94nvhw8ve31/Miyagi_-_Get_Up_63451010.mp3?rlkey=t5vqb9mualsgx6h74fnex5621&st=fmxzg5in&dl=1");
                case 3: format(url, size, "https://www.dropbox.com/scl/fi/hfmqjpmm0navad5f5911m/Miyagi_-_Bejjba_sudba_47829400.mp3?rlkey=l6fiiuegjqlgt7e2w0qpyxqmd&st=7r3uh3vw&dl=1");
                case 4: format(url, size, "https://www.dropbox.com/scl/fi/58f5sh1tdmiviitoc91ww/Miyagi_Rem_Digga_-_I_Got_Love_47828425.mp3?rlkey=ggv9s5vkx7zt9n7m8gg6cgmb6&st=vfzivlnd&dl=1");
            }
        }
        case 3:
        {
            switch(trackid)
            {
                case 0: format(url, size, "https://www.dropbox.com/scl/fi/tjqhslumyo9g2epweuf9n/ZXKAI_-_NO_BATIDO_Slowed_80038114-1.mp3?rlkey=3sjxbmqdwag83i4w08jmxp63m&st=5eufiej8&dl=1");
                case 1: format(url, size, "https://www.dropbox.com/scl/fi/bwzo6wp4dwn57j0k8hdjf/2_5370637294027967655.m4a?rlkey=772cwhfevsfrtd8hesoby4k0v&st=f7ysqa9g&dl=1");
                case 2: format(url, size, "https://www.dropbox.com/scl/fi/9qea50mskw8pztn9gbh93/FUNK-ABNORMAL-DJ-V12-x-SXID-SLOWED-1.m4a?rlkey=5tyt6wbynvgk5gb0xi5hjuhhv&st=zviyrzr7&dl=1");
                case 3: format(url, size, "https://www.dropbox.com/scl/fi/hip87ayllu4prrdhd1e4k/qaraqshy-MONTAGEM-SANTA-FE-2.m4a?rlkey=neu14aat2a7i69p0ddlwy0ele&st=qv8tqm20&dl=1");
                case 4: format(url, size, "https://www.dropbox.com/scl/fi/hc02tba0m1b83yup6jany/DIPIENS-HRXSTAL-PPAPTEKK-www.lightaudio.ru.mp3?rlkey=15aoamxv1pdkburlt9zue3q4l&st=6jv592ns&dl=1");
            }
        }
        case 4:
        {
            switch(trackid)
            {
                case 0: format(url, size, "https://www.dropbox.com/scl/fi/a9cap2mbfzkwm58h3la2q/Gazan_-_CHEREMSHA_81433948.mp3?rlkey=5psz8wzak2h1ziytr9nw7c44s&st=4nc5fgcv&dl=1");
                case 1: format(url, size, "https://www.dropbox.com/scl/fi/ycbo0s8sr1ccduguxbx2p/Gazan_-_67_Six_Seven_80858207.mp3?rlkey=o3aywtjxqhqk3r08jwscisein&st=ppx3kiw6&dl=1");
                case 2: format(url, size, "https://www.dropbox.com/scl/fi/rrodxrpzko7fcjuygelzm/9_gramm_-_Djens_76249087.mp3?rlkey=j7pfnwlqwa60l6ib1jui28egh&st=zatjb2c0&dl=1");
                case 3: format(url, size, "https://www.dropbox.com/scl/fi/188uu4tefh1cub4514ekj/DEAD_BLONDE_-_Bankomat_75072215.mp3?rlkey=dgjmq2rlkm1zcapcf2rg3la8y&st=3si1vdg4&dl=1");
                case 4: format(url, size, "https://www.dropbox.com/scl/fi/cxxbkkjt33rn4jge80y8u/CHELOVEK_YAJJCA_-_ZALETARIKI_80511904.mp3?rlkey=ps45fp2b8g5rf6ajherys95bw&st=ktwa2f1a&dl=1");
            }
        }
        case 5:
        {
            switch(trackid)
            {
                case 0: format(url, size, "https://www.dropbox.com/scl/fi/h7xdynhm1eu8a5qa9gvqd/.-www.lightaudio.ru.mp3?rlkey=8qic4agfmxlisxne5udup8d06&st=g1sgj6mo&dl=1");
                case 1: format(url, size, "https://www.dropbox.com/scl/fi/dvmzsinvsuj12ygnmnz7y/Viktor_Cojj_-_KHochu_peremen_47828893.mp3?rlkey=86hu1fzzshnz94bwsyu4gn512&st=dlctgjcs&dl=1");
                case 2: format(url, size, "https://www.dropbox.com/scl/fi/lufefmzmu65foixxim134/Viktor_Cojj_-_Gruppa_krovi_47828908.mp3?rlkey=1b9vzuk62gjlzexalhr28ci1a&st=cnhmjdr3&dl=1");
                case 3: format(url, size, "https://www.dropbox.com/scl/fi/4f5nhyp2wlnh5il0basxh/.mp3?rlkey=892mvue2m7de5j1zm97d7j8k6&st=xw1zbv63&dl=1");
                case 4: format(url, size, "https://www.dropbox.com/scl/fi/dzma0wy8y900yungemm34/Viktor_Cojj_-_Zvezda_po_imeni_Solnce_64373500.mp3?rlkey=okrsecmsjcmyye6vw9hlncm7x&st=tfzhkpxk&dl=1");
            }
        }
    }
    return 1;
}

stock bool:Music_PlayerHasAlbum(playerid, albumid)
{
    if(albumid < 0 || albumid >= MUSIC_ALBUM_COUNT) return false;
    Music_InitDatabase();

    new query[160];
    mysql_format(mysql, query, sizeof query,
        "SELECT `id` FROM `music_albums` WHERE `uid`=%d AND `album_id`=%d LIMIT 1",
        GetPlayerAccountID(playerid), albumid);
    mysql_query(mysql, query, true);

    new bool:has = (cache_num_rows() > 0);
    cache_delete(); // ИСПРАВЛЕНО: не освобождался кэш MySQL — утечка при каждом вызове (а вызывается он на каждый альбом при каждой отрисовке списка)
    return has;
}

stock Music_SaveAlbum(playerid, albumid)
{
    if(albumid < 0 || albumid >= MUSIC_ALBUM_COUNT) return 0;
    Music_InitDatabase();

    new query[192];
    mysql_format(mysql, query, sizeof query,
        "INSERT IGNORE INTO `music_albums` (`uid`, `album_id`, `created_at`) VALUES (%d, %d, %d)",
        GetPlayerAccountID(playerid), albumid, gettime());
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock Music_TakeDonate(playerid, amount)
{
    if(GetPlayerDonateRub(playerid) < amount) return 0;
    GivePlayerDonateRub(playerid, -amount, "Покупка музыкального альбома", true, true);
    return 1;
}


stock Music_ReplaceUrlPart(url[], const search[], const replace[], size)
{
    new pos = strfind(url, search, true);
    if(pos == -1) return 0;

    strdel(url, pos, pos + strlen(search));
    strins(url, replace, pos, size);
    return 1;
}

stock Music_NormalizeDropboxUrl(const source[], url[], size)
{
    format(url, size, "%s", source);

    if(strfind(url, "dropbox.com", true) == -1 && strfind(url, "dropboxusercontent.com", true) == -1)
        return 1;

    // SA-MP audio player needs a direct file stream, not the Dropbox web page.
    // These replacements keep your links in Music_GetPaidTrackUrl unchanged,
    // but before playback convert them to a direct Dropbox content URL.
    Music_ReplaceUrlPart(url, "https://www.dropbox.com/", "https://dl.dropboxusercontent.com/", size);
    Music_ReplaceUrlPart(url, "http://www.dropbox.com/", "https://dl.dropboxusercontent.com/", size);
    Music_ReplaceUrlPart(url, "https://dropbox.com/", "https://dl.dropboxusercontent.com/", size);
    Music_ReplaceUrlPart(url, "http://dropbox.com/", "https://dl.dropboxusercontent.com/", size);
    Music_ReplaceUrlPart(url, "https://dl.dropbox.com/", "https://dl.dropboxusercontent.com/", size);
    Music_ReplaceUrlPart(url, "http://dl.dropbox.com/", "https://dl.dropboxusercontent.com/", size);

    if(Music_ReplaceUrlPart(url, "dl=0", "raw=1", size)) return 1;
    if(Music_ReplaceUrlPart(url, "dl=1", "raw=1", size)) return 1;
    if(Music_ReplaceUrlPart(url, "raw=0", "raw=1", size)) return 1;
    if(strfind(url, "raw=1", true) != -1) return 1;

    if(strfind(url, "?", true) != -1) strcat(url, "&raw=1", size);
    else strcat(url, "?raw=1", size);

    return 1;
}

stock Music_Play(playerid, tabid, bool:premium, const track_name[], const url[])
{
    if(strlen(url) < 8)
    {
        SendClientMessage(playerid, -1, ""SC"Ссылка на этот трек не настроена.");
        return 1;
    }

    musicOn[playerid] = 1;
    g_music_active_tab[playerid] = tabid;
    g_music_active_premium[playerid] = premium;
    format(g_music_active_name[playerid], 96, "%s", track_name);

    new stream_url[384];
    Music_NormalizeDropboxUrl(url, stream_url, sizeof stream_url);
    PlayAudioStreamURL(playerid, stream_url);

    new msg[160];
    format(msg, sizeof msg, ""SC"Трек {FFFF00}%s {FFFFFF}включен.", track_name);
    SendClientMessage(playerid, -1, msg);
    Action(playerid, "Включил(-а) музыку в транспортном средстве", _, false);
    return 1;
}

stock Music_PlayFreeTrack(playerid, trackid)
{
    if(trackid < 0 || trackid >= MUSIC_FREE_TRACK_COUNT) return 1;

    new name[96], url[384];
    Music_GetFreeTrackName(trackid, name, sizeof name);
    Music_GetFreeTrackUrl(trackid, url, sizeof url);
    return Music_Play(playerid, MUSIC_TAB_FREE, false, name, url);
}

stock Music_PlayPaidTrack(playerid, albumid, trackid)
{
    if(albumid < 0 || albumid >= MUSIC_ALBUM_COUNT) return 1;
    if(trackid < 0 || trackid >= MUSIC_PAID_TRACKS_PER_ALBUM) return 1;

    new track_name[96], url[384];
    Music_GetPaidTrackName(albumid, trackid, track_name, sizeof track_name);
    Music_GetPaidTrackUrl(albumid, trackid, url, sizeof url);
    return Music_Play(playerid, MUSIC_TAB_PREMIUM, true, track_name, url);
}


stock Music_OpenMain(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, -1, ""SC"Включение {FFFF00}музыки {FFFFFF}доступно только в {FFFF00}транспорте");
        return 1;
    }

    ShowPlayerDialog(playerid, DIALOG_MUSIC_MAIN, DIALOG_STYLE_LIST, "{FFAE00}Музыка",
    "Радиостанции (бесплатно)\nБиблиотека (платные альбомы)", "Выбрать", "Закрыть");
    return 1;
}

stock Music_ShowFreeDialog(playerid)
{
    new list[700], name[96];
    list[0] = EOS;
    for(new i = 0; i < MUSIC_FREE_TRACK_COUNT; i++)
    {
        Music_GetFreeTrackName(i, name, sizeof name);
        strcat(list, name, sizeof list);
        strcat(list, "\n", sizeof list);
    }
    ShowPlayerDialog(playerid, DIALOG_MUSIC_FREE, DIALOG_STYLE_LIST, "{FFAE00}Радиостанции", list, "Включить", "Назад");
    return 1;
}

stock Music_ShowAlbumsDialog(playerid)
{
    new list[900], album_name[96], item_text[128];
    list[0] = EOS;
    for(new i = 0; i < MUSIC_ALBUM_COUNT; i++)
    {
        Music_GetAlbumName(i, album_name, sizeof album_name);
        format(item_text, sizeof item_text, "%s\n", album_name);
        strcat(list, item_text, sizeof list);
    }
    ShowPlayerDialog(playerid, DIALOG_MUSIC_ALBUMS, DIALOG_STYLE_LIST, "{FFAE00}Библиотека", list, "Выбрать", "Назад");
    return 1;
}

stock Music_ShowTracksDialog(playerid, albumid)
{
    if(albumid < 0 || albumid >= MUSIC_ALBUM_COUNT) return Music_ShowAlbumsDialog(playerid);

    g_music_selected_album[playerid] = albumid;

    new list[700], track_name[96];
    list[0] = EOS;
    for(new i = 0; i < MUSIC_PAID_TRACKS_PER_ALBUM; i++)
    {
        Music_GetPaidTrackName(albumid, i, track_name, sizeof track_name);
        strcat(list, track_name, sizeof list);
        strcat(list, "\n", sizeof list);
    }
    ShowPlayerDialog(playerid, DIALOG_MUSIC_TRACKS, DIALOG_STYLE_LIST, "{FFAE00}Треки альбома", list, "Включить", "Назад");
    return 1;
}

stock Music_HandlePremiumAlbumClick(playerid, albumid)
{
    // ИЗМЕНЕНО: библиотека теперь полностью бесплатная — сразу показываем треки, без доната
    if(albumid < 0 || albumid >= MUSIC_ALBUM_COUNT) return 1;
    return Music_ShowTracksDialog(playerid, albumid);
    return 1;
}

stock Music_ConfirmBuyAlbum(playerid)
{
    new albumid = g_music_selected_album[playerid];
    if(albumid < 0 || albumid >= MUSIC_ALBUM_COUNT) return Music_ShowAlbumsDialog(playerid);

    if(!Music_TakeDonate(playerid, MUSIC_ALBUM_PRICE))
    {
        new msg[144];
        format(msg, sizeof msg, ""SC"Недостаточно доната. Нужно {FFFF00}%d доната{FFFFFF}, у вас {FFFF00}%d{FFFFFF}.", MUSIC_ALBUM_PRICE, GetPlayerDonateRub(playerid));
        SendClientMessage(playerid, -1, msg);
        return Music_ShowAlbumsDialog(playerid);
    }

    Music_SaveAlbum(playerid, albumid);

    new album_name[96], msg[160];
    Music_GetAlbumName(albumid, album_name, sizeof album_name);
    format(msg, sizeof msg, ""SC"Вы купили альбом/плейлист {FFFF00}%s {FFFFFF}за {FFFF00}%d доната{FFFFFF}.", album_name, MUSIC_ALBUM_PRICE);
    SendClientMessage(playerid, -1, msg);

    return Music_ShowTracksDialog(playerid, albumid);
}

stock Music_Stop(playerid)
{
    if(musicOn[playerid] == 0)
    {
        SendClientMessage(playerid, -1, "{FF5252}Музыка не включена");
        return 1;
    }

    StopAudioStream(playerid);
    musicOn[playerid] = 0;
    g_music_active_tab[playerid] = MUSIC_TAB_FREE;
    g_music_active_premium[playerid] = false;
    g_music_active_name[playerid][0] = EOS;
    SendClientMessage(playerid, -1, "{2ECC71}Музыка выключена");
    Action(playerid, "Выключил(-а) музыку в транспортном средстве", _, false);
    return 1;
}

// ==================================================================================
// Диалоги (полностью заменяют кастомную GUI id 9 — надёжнее, не зависит от схемы
// чужого клиента). CMD:music открывает список станций/библиотеки обычным диалогом.
// ==================================================================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_MUSIC_MAIN)
    {
        if(!response) return 1;
        if(listitem == 0) return Music_ShowFreeDialog(playerid);
        return Music_ShowAlbumsDialog(playerid);
    }

    if(dialogid == DIALOG_MUSIC_FREE)
    {
        if(!response) return Music_OpenMain(playerid);
        return Music_PlayFreeTrack(playerid, listitem);
    }

    if(dialogid == DIALOG_MUSIC_ALBUMS)
    {
        if(!response) return Music_OpenMain(playerid);
        return Music_HandlePremiumAlbumClick(playerid, listitem);
    }

    if(dialogid == DIALOG_MUSIC_TRACKS)
    {
        if(!response) return Music_ShowAlbumsDialog(playerid);
        return Music_PlayPaidTrack(playerid, g_music_selected_album[playerid], listitem);
    }

    if(dialogid == DIALOG_MUSIC_BUY)
    {
        if(!response) return Music_ShowAlbumsDialog(playerid);
        return Music_ConfirmBuyAlbum(playerid);
    }

    #if defined music_OnDialogResponse
        return music_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse music_OnDialogResponse
#if defined music_OnDialogResponse
    forward music_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

CMD:music(playerid)
{
    return Music_OpenMain(playerid);
}

CMD:smusic(playerid)
{
    return Music_Stop(playerid);
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(musicOn[playerid] == 1)
    {
        SendClientMessage(playerid, -1, ""SC"Вы вышли из транспорта, музыка выключена");
        StopAudioStream(playerid);
        Action(playerid, "Выключил(-а) музыку в транспортном средстве", _, false);
        musicOn[playerid] = 0;
        g_music_active_name[playerid][0] = EOS;
    }

    #if defined music_OnPlayerExitVehicle
        return music_OnPlayerExitVehicle(playerid, vehicleid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerExitVehicle
#undef OnPlayerExitVehicle
#else
#define _ALS_OnPlayerExitVehicle
#endif
#define OnPlayerExitVehicle music_OnPlayerExitVehicle
#if defined music_OnPlayerExitVehicle
forward music_OnPlayerExitVehicle(playerid, vehicleid);
#endif

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(!ispassenger)
    {
        SetTimerEx("InMusicTimer", 2200, false, "i", playerid);
        if(GetVehicleParamEx(vehicleid, V_ENGINE) != VEHICLE_PARAM_ON)
        {
            SetTimerEx("InCarTimer", 2200, false, "i", playerid);
        }
    }

    #if defined music_OnPlayerEnterVehicle
        return music_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerEnterVehicle
#undef OnPlayerEnterVehicle
#else
#define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle music_OnPlayerEnterVehicle
#if defined music_OnPlayerEnterVehicle
forward music_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

forward InCarTimer(playerid);
public InCarTimer(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
    {
        SetTimerEx("InCarTimer", 1500, false, "i", playerid);
    }
    return 1;
}

forward InMusicTimer(playerid);
public InMusicTimer(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, -1, ""SC"Для включения {FFFF00}музыки {FFFFFF}в транспортном средстве используйте {FFFF00}/music");
    }
    else
    {
        SetTimerEx("InMusicTimer", 1500, false, "i", playerid);
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    musicOn[playerid] = 0;
    g_music_gui_page[playerid][MUSIC_TAB_FREE] = 1;
    g_music_gui_page[playerid][MUSIC_TAB_PREMIUM] = 1;
    g_music_selected_album[playerid] = 0;
    g_music_premium_tracks[playerid] = false;
    g_music_active_tab[playerid] = MUSIC_TAB_FREE;
    g_music_active_premium[playerid] = false;
    g_music_active_name[playerid][0] = EOS;

    #if defined music_OnPlayerDisconnect
        return music_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
#undef OnPlayerDisconnect
#else
#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect music_OnPlayerDisconnect
#if defined music_OnPlayerDisconnect
forward music_OnPlayerDisconnect(playerid, reason);
#endif
