// хз нече делать было, вот написал на своём мега сасунге

new musicOn[MAX_PLAYERS];
#define DIALOG_VIBOR_MUZIKA 9674
#define DIALOG_PLAYLIST 9675
#define DIALOG_VIBOR_RADIO 9676
#define SC "{FFFF00}| {FFFFFF}"

CMD:music(playerid) // уберите /music старый пж
{
 if(!IsPlayerInAnyVehicle(playerid))
 {
  SendClientMessage(playerid, -1, ""SC"Включение {FFFF00}музыки {FFFFFF}доступно только в {FFFF00}транспорте");
 }
  else
  {
    ShowPlayerDialog(playerid, DIALOG_VIBOR_MUZIKA, DIALOG_STYLE_TABLIST_HEADERS,
                    "{FFD700}LIME RUSSIA {FFFFFF}| Выберите нужное действие",
                    "№\tНазвание\tДействие\n"\
                    "{FFD700}1\t{FFFFFF}Радио\t{BEBEBE}Выбор радиостанций\n"\
                    "{FFD700}2\t{FFFFFF}Готовый плейлист\t{BEBEBE}Выбор из плейлиста\n"\
                    "{FFD700}3\t{FFD700}Выключить музыку\t{BEBEBE}Выключение песни",
                    "Выбрать", "Отмена");
                    return 1;
    } 
    
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

if(dialogid == DIALOG_VIBOR_RADIO)
{
    if(response)
    {
        musicOn[playerid] = 1;
        switch(listitem)
        {
          case 0:
          {
             PlayAudioStreamURL(playerid, "http://dfm.hostingradio.ru/dfm128.mp3");
             SendClientMessage(playerid, -1, ""SC"Радио {FFFF00}«DFM» {FFFFFF}успешно включено");
          }
          case 1:
          {
             PlayAudioStreamURL(playerid, "http://hitfm.hostingradio.ru/hitfm128.mp3");
             SendClientMessage(playerid, -1, ""SC"Радио {FFFF00}«Hit-FM» {FFFFFF}успешно включено");
           } 
           case 2:
           {
              PlayAudioStreamURL(playerid, "http://rusradio.hostingradio.ru/rusradio128.mp3");
             SendClientMessage(playerid, -1, ""SC"Радио {FFFF00}«Русское радио» {FFFFFF}успешно включено");
            }
          } 
      }
} 

if(dialogid == DIALOG_VIBOR_MUZIKA)
{
    if(response)
    {
        switch(listitem)
        {
          case 0:
          {
             ShowDialogRadio(playerid);
          } 
          case 1:
          {
              ShowDialogPlaylist(playerid);
          }
          case 2:
          {
             if(musicOn[playerid] == 0)
             {
               ShowNotificationSander(playerid, 2, 6, 0, 0, "Музыка не включена", "");
             } 
             else
             {
              StopAudioStream(playerid);
              ShowNotificationSander(playerid, 2, 6, 0, 0, "Музыка выключена", "");
              Action(playerid, "Выключил(-а) музыку в транспортном средстве", _, false);
             }
           }
          } 
     }
} 
 if(dialogid == DIALOG_PLAYLIST)
{
    if(response)
    {
        musicOn[playerid] = 1;
       Action(playerid, "Включил(-а) музыку в транспортном средстве", _, false);
        switch(listitem)
        {
            case 0:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20201211/nuor_garsas_-_ozon_71929210.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Ozon' {FFFFFF}включена.");
            }
            case 1:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20260531/LOURENZ_-_Myuli_81592474.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Мюли' {FFFFFF}включена.");
            }
            case 2:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20200515/Miyagi_Andy_Panda_TumaniYO_-_Brooklyn_69553060.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Miyagi Brooklyn' {FFFFFF}включена.");
            }
            case 3:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20231227/timmitheboy_face_yanix_-_wassup_77161289.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'timmitheboy face yanix - wassup' {FFFFFF}включена.");
            }
            case 4:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20260128/RAW_NOIZE_-_Versatile_-_Hartekk_TikTok_version_80726354.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Versatile' {FFFFFF}включена.");
            }
            case 5:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20190505/jeldzhjejj_-_a_boshki_dymyatsya_podruzhki_skuchayut_63981576.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Элджэй - бошки дымятся' {FFFFFF}включена.");
            }
            case 6:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20220603/ANNA_ASTI_-_Po_baram_74376135.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'ANNA ASTI - По барам' {FFFFFF}включена.");
            }
            case 7:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20190914/kis-kis_-_molchi_66563229.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'МОЛЧИ' {FFFFFF}включена.");
            }
            case 8:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20230817/Crazy_Frog_-_axel_f_slowed_and_reverb_76585874.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Axel - F' {FFFFFF}включена.");
            }
            case 9:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20201119/King_Von_-_Took_Her_To_The_O_71659917.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'King Von - Took Her To The O' {FFFFFF}включена.");
            }
            case 10:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20210301/Ramil_-_Pero_pod_rebro_72818957.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Ramil - Перо под ребро' {FFFFFF}включена.");
            }
            case 11:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250821/4K_-_Miliciya_79518189.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Милиция - 4К' {FFFFFF}включена.");
            }
            case 12:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20150907/Imany_-_Dont_Be_So_Shy_28583428.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Imany - Dont Be So Shy' {FFFFFF}включена.");
            }
            case 13:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20250104/La_Bouche_-_Be_My_Lover_speed_up_78871815.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'La Bouche - Be My Lover' {FFFFFF}включена.");
            }
            case 14:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20190408/Alij_-_Gulyaem_marivanna_63382171.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Alij - Гуляем мариванна' {FFFFFF}включена.");
            }
            case 15:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmoz.org/get/music/20240623/ZATUS_-_Plejjlist_dlya_khasana_78023161.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'ЗАТУС - Плейлист для хасана' {FFFFFF}включена.");
            }
            case 16:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250908/Melodiya_na_zvonok_VLEZENDA_-_ONK_MIRA_79695663.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'FONK 1' {FFFFFF}включена.");
            }
            case 17:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250829/ONK_-_MORTAL_COMBAT_PHONK_79602507.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'FONK 2' {FFFFFF}включена.");
            }
            case 18:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20231214/ONK_pHonk_-_PHONK_DLYA_DRITA_77075100.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'FONK 3' {FFFFFF}включена.");
            }
            case 19:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250829/Maks_Korzh_-_Malyjj_povzroslel_79603776.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Макс Корж - Малый повзрослел' {FFFFFF}включена.");
            }
        }
       
    }
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




public OnPlayerExitVehicle(playerid, vehicleid)
{
   if(musicOn[playerid] == 1)
   {
        SendClientMessage(playerid, -1, ""SC"Вы вышли из транспорта, музыка выключена");
        StopAudioStream(playerid);
        Action(playerid, "Выключил(-а) музыку в транспортном средстве", _, false);
        musicOn[playerid] = 0;
        return 1;
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


forward InCarTimer(playerid); // таймер на увед шоб завести тачку
public: InCarTimer(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
       
    }
    else
    {
       SetTimerEx("InCarTimer", 1500, false, "i", playerid); // эт если человек например далеко от т/с был и нажал сесть то тех 2200 миллисекунд недостаточно и таймер повторяется да тех пор пока игрок все таки не сядет ок. 
    }
	return 1;
}

forward InMusicTimer(playerid); // таймер сообщения о том шо можно музыку вкл
public: InMusicTimer(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
       SendClientMessage(playerid, -1, ""SC"Для включения {FFFF00}музыки {FFFFFF}в транспортном средстве используйте {FFFF00}/music");
    }
    else
    {
       SetTimerEx("InMusicTimer", 1500, false, "i", playerid); // эт если человек например далеко от т/с был и нажал сесть то тех 2200 миллисекунд недостаточно и таймер повторяется да тех пор пока игрок все таки не сядет ок. 
    }
	return 1;
}


stock ShowDialogRadio(playerid)
{
   ShowPlayerDialog(playerid, DIALOG_VIBOR_RADIO, DIALOG_STYLE_LIST,
                    "{FFD700}LIME RUSSIA {FFFFFF}| Выберите нужную радиостанцию",
                    "Радиостанция «DFM»\nРадиостанция «Hit FM»\nРадиостанция «Русское радио»",
                    "Включить", "Отмена");
 return 1;
} 

stock ShowDialogPlaylist(playerid)
{
   ShowPlayerDialog(playerid, DIALOG_PLAYLIST, DIALOG_STYLE_LIST,
                    "{FFD700}LIME RUSSIA {FFFFFF}| Аудио-система автомобиля",
                    "Ozon\nМюли\nMiyagi-Brooklyn\ntimmitheboy face yanix - wassup\nVersatile\nЭлджэй - бошки дымятся\nANNA ASTI - По барам\nМОЛЧИ\nAxel - F\nKing Von - Took Her To The O\nRamil - Перо под ребро\nМилиция - 4К\nImany - Dont Be So Shy\nLa Bouche - Be My Lover\nAlij - Гуляем мариванна\nЗАТУС - Плейлист для хасана\nFONK 1\nFONK 2\nFONK 3\nМакс Корж - Малый повзрослел",
                    "Включить", "Отмена");
                    return 1;
} 

public OnPlayerDisconnect(playerid, reason)
{
   if(musicOn[playerid] > 0)
   {
     musicOn[playerid] = 0; // ну типа чтобы багов не было если игрок с айди например 3 вышел и потом другой игрок зашёл под этим же айди
   }

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

 
 
// вроде бы система фулл готова бай ветол


// след систему иду писать эт покупка випок наверн в донате или хз чо ем ну пон. 