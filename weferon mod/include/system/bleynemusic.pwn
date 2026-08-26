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
                    "{CA5757}BEST RUSSIA {FFFFFF}| Выберите нужное действие",
                    "№\tНазвание\tДействие\n"\
                    "{CA5757}1\t{FFFFFF}«Радио»\t{BEBEBE}Выбор радиостанций\n"\
                    "{CA5757}2\t{FFFFFF}«Готовый плейлист»\t{BEBEBE}Выбор из плейлиста\n"\
                    "{CA5757}3\t{CA5757}«Выключить музыку»\t{BEBEBE}Выключение песни",
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
               ShowNotificationLaird(playerid, 2, 6, 0, 0, "Музыка не включена", "");
             } 
             else
             {
              StopAudioStream(playerid);
              ShowNotificationLaird(playerid, 2, 6, 0, 0, "Музыка выключена", "");
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
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250814/whitek3d_-_Katyukha_79431776.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Катюха' {FFFFFF}включена.");
            }
            case 1:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250915/Brr_Brr_Patapim_-_Brainrot_Rap_Brr_Brr_Patapim_79759680.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Brainrot Rap' {FFFFFF}включена.");
            }
            case 2:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitаmotop.com/get/music/20170830/Miyagi_Rem_Digga_-_I_Got_Love_47828425.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Miyagi & Эндшпиль - I Got Love' {FFFFFF}включена.");
            }
            case 3:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250815/bridge_-_LABUBA_79438066.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'ЛАБУБА' {FFFFFF}включена.");
            }
            case 4:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250910/Prosto_Lera_x_Remini_-_Prosto_Lera_-_Mne_ne_20_mne_27_feat_Remini_-_Mne_20_79712597.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'МНЕ НЕ 20, мне 27' {FFFFFF}включена.");
            }
            case 5:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250811/Morgenshtern_-_Cadillac_79397758.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'MORGENSHTERN - Cadillac' {FFFFFF}включена.");
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
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250813/ivanzolo2004_-_Marabu_79418317.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Иван zolo - Марабу' {FFFFFF}включена.");
            }
            case 9:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20230407/MACAN_-_ASPHALT_8_75722766.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'MACAN - АСФАЛЬТ 8' {FFFFFF}включена.");
            }
            case 10:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250322/madk1d_-_tak_po_79098630.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Так пох#й' {FFFFFF}включена.");
            }
            case 11:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250821/4K_-_Miliciya_79518189.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Милиция - 4К' {FFFFFF}включена.");
            }
            case 12:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20170830/MakSim_-_Znaesh_li_ty_47835999.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'MAKSIM - Знаешь ли ты' {FFFFFF}включена.");
            }
            case 13:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250426/mzlff_-_vo_dvore_79157839.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'mzlff - во дворе' {FFFFFF}включена.");
            }
            case 14:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250519/Artur_Pirozhkov_-_Samo_Sobojj_79186666.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Артур Пирожков - Само собой' {FFFFFF}включена.");
            }
            case 15:
            {
                PlayAudioStreamURL(playerid, "https://rus.hitmotop.com/get/music/20250819/EGOR_KRID_Tenderlybae_SHkred_-_Pacanskijj_FONK_79487186.mp3");
                SendClientMessage(playerid, -1, ""SC"Песня {FFFF00}'Пацанский фонк - ЕГОР КРИД' {FFFFFF}включена.");
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
       ShowNotificationLaird(playerid, 6, 6, ENTER_ENGINE, 0, "Двигатель автомобиля выключен", "Включить");
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
                    "{CA5757}BEST RUSSIA {FFFFFF}| Выберите нужную радиостанцию",
                    "Радиостанция «DFM»\nРадиостанция «Hit FM»\nРадиостанция «Русское радио»",
                    "Включить", "Отмена");
 return 1;
} 

stock ShowDialogPlaylist(playerid)
{
   ShowPlayerDialog(playerid, DIALOG_PLAYLIST, DIALOG_STYLE_LIST,
                    "{CA5757}BEST RUSSIA {FFFFFF}| Аудио-система автомобиля",
                    "Катюха\nBrainrot Rap\nMiyagi & Эндшпиль - I Got Love\nЛАБУБА\nМНЕ НЕ 20, мне 27\nMORGENSHTERN - Cadillac\nANNA ASTI - По барам\nМОЛЧИ\nИван zolo - Марабу\nMACAN - АСФАЛЬТ 8\nТак пох#й\nМилиция - 4К\nMAKSIM - Знаешь ли ты\nmzlff - во дворе\nАртур Пирожков - Само собой\nПацанский фонк - ЕГОР КРИД\nFONK 1\nFONK 2\nFONK 3\nМакс Корж - Малый повзрослел",
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