#define DSI DIALOG_STYLE_INPUT
#define DSL DIALOG_STYLE_LIST  
#define H_T_OBJECT 1
#define H_T_3DTEXT 2
#define H_T_ACTOR  3
#define H_T_PICKUP 4
#define H_T_SHPERE 5
#define MAX_CREATE 75

// Position
new Text:g_CreateControlTextDraws[10];
#define TD_XYZ_MAIN     0
#define TD_XYZ_WASD     1
#define TD_XYZ_UP_DOWN  2
#define TD_XYZ_OFF      3
#define TD_XYZ_FORWARD  4
#define TD_XYZ_BACKWARD 5
#define TD_XYZ_LEFT     6
#define TD_XYZ_RIGHT    7
#define TD_XYZ_UP       8
#define TD_XYZ_DOWN     9
// Rotation
new Text:g_CreateRotateTextDraws[7];
#define TD_ROTATION_MAIN       0
#define TD_ROTATION_X_left     1
#define TD_ROTATION_X_right    2
#define TD_ROTATION_Y_left     3
#define TD_ROTATION_Y_right    4
#define TD_ROTATION_Z_left     5
#define TD_ROTATION_Z_right    6
// переключение режимов
#define TD_POSITION_BUTTON     1
#define TD_ROTATION_BUTTON     2
new PlayerText:g_CreateTypePlayerTextDraws[MAX_PLAYERS][3];

enum HELP_CREATE
{
   H_TYPE,
   H_ID_NET,
   H_ID_OBJ,
   Text3D:H_ID_NET_3D,
   H_STRING[24],
   Float:H_X,
   Float:H_Y,
   Float:H_Z,
   Float:H_S    
}

new tracking_object_id[MAX_PLAYERS];
new is_editing_object[MAX_PLAYERS];
new type_create[5][9] = {"Объект","3D Текст","Актер","Пикап","Сфера"};

new l_create[MAX_CREATE][HELP_CREATE];
new set_timer_create[MAX_PLAYERS];

cmd:create(playerid)
{
    if(id_cr() >= MAX_CREATE) SCM(playerid,-1,"Объектов больше чем ограничение");
    
    Dialog
    (
     playerid, 5011, DSL,
     "Помощник в создании | Меню",
     "Создать\n"\
     "Удалить\n"\
     "Список созданных",
     "Далее","Выйти"
    );
}

stock id_cr()
{
   new n;

   for(new w; w < MAX_CREATE;w++)
   {
      if(l_create[w][H_TYPE] == 0) 
      {
         n = w;
         break;
      }
   }

   return n;
}

public OnGameModeInit()
{
    // Сохранить и выйти
    g_CreateControlTextDraws[TD_XYZ_OFF] = TextDrawCreate(600.1993, -2.5466, "txd:transparent");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_OFF], 40.0000, 46.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_OFF], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_OFF], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_OFF], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_OFF], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_OFF], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_OFF], 0);
    TextDrawSetSelectable(g_CreateControlTextDraws[TD_XYZ_OFF], true);
    // решил отдельный сток не создавать

    CreateTextDrawCreateXYZ();
    CreateTextDrawCreateRotation();

    #if defined cr_OnGameModeInit
        return cr_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit cr_OnGameModeInit
#if defined cr_OnGameModeInit
    forward cr_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
   // текстдрав с информацией о выбранном режиме
    g_CreateTypePlayerTextDraws[playerid][0] = CreatePlayerTextDraw(playerid, 271.0000, 388.5200, "txd:create_position");
    PlayerTextDrawTextSize(playerid, g_CreateTypePlayerTextDraws[playerid][0], 84.0000, 48.0000);
    PlayerTextDrawAlignment(playerid, g_CreateTypePlayerTextDraws[playerid][0], 1);
    PlayerTextDrawColor(playerid, g_CreateTypePlayerTextDraws[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, g_CreateTypePlayerTextDraws[playerid][0], 255);
    PlayerTextDrawFont(playerid, g_CreateTypePlayerTextDraws[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, g_CreateTypePlayerTextDraws[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, g_CreateTypePlayerTextDraws[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, g_CreateTypePlayerTextDraws[playerid][0], true);

    // это кнопки для переключения режимов
    // Кнопка "Position"
    g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON] = CreatePlayerTextDraw(playerid, 276.5000, 393.0000, "txd:transparent");
    PlayerTextDrawTextSize(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], 37.0000, 40.0000);
    PlayerTextDrawAlignment(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], 1);
    PlayerTextDrawColor(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], -1);
    PlayerTextDrawBackgroundColor(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], 255);
    PlayerTextDrawFont(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], 4);
    PlayerTextDrawSetProportional(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], 0);
    PlayerTextDrawSetShadow(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], 0);
    PlayerTextDrawSetSelectable(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON], true);

    // Кнопка "Rotation"
    g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON] = CreatePlayerTextDraw(playerid, 313.5000, 392.4400, "txd:transparent");
    PlayerTextDrawTextSize(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], 38.0000, 40.0000);
    PlayerTextDrawAlignment(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], 1);
    PlayerTextDrawColor(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], -1);
    PlayerTextDrawBackgroundColor(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], 255);
    PlayerTextDrawFont(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], 4);
    PlayerTextDrawSetProportional(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], 0);
    PlayerTextDrawSetShadow(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], 0);
    PlayerTextDrawSetSelectable(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON], true);

    #if defined cr_OnPlayerConnect
        return cr_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect cr_OnPlayerConnect
#if defined cr_OnPlayerConnect
    forward cr_OnPlayerConnect(playerid);
#endif

// вырезал с системы спека
stock CreateTextDrawCreateXYZ()
{
	// Фон
    g_CreateControlTextDraws[TD_XYZ_MAIN] = TextDrawCreate(-2.2000, 0.0000, "txd:fly_main");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_MAIN], 644.0000, 448.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_MAIN], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_MAIN], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_MAIN], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_MAIN], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_MAIN], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_MAIN], 0);

    // кнопки: вперед, назад, вправо, влево
    g_CreateControlTextDraws[TD_XYZ_WASD] = TextDrawCreate(60.0000, 252.0000, "txd:fly_wasd");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_WASD], 100.0000, 146.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_WASD], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_WASD], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_WASD], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_WASD], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_WASD], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_WASD], 0);

    // кнопки: вверх, вниз
    g_CreateControlTextDraws[TD_XYZ_UP_DOWN] = TextDrawCreate(536.0000, 269.0000, "txd:fly_up_down");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_UP_DOWN], 36.0000, 130.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_UP_DOWN], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_UP_DOWN], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_UP_DOWN], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_UP_DOWN], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_UP_DOWN], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_UP_DOWN], 0);

    // Вперед
    g_CreateControlTextDraws[TD_XYZ_FORWARD] = TextDrawCreate(94.0000, 252.0000, "txd:transparent");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_FORWARD], 34.0000, 47.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_FORWARD], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_FORWARD], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_FORWARD], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_FORWARD], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_FORWARD], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_FORWARD], 0);
    TextDrawSetSelectable(g_CreateControlTextDraws[TD_XYZ_FORWARD], true);

    // Назад
    g_CreateControlTextDraws[TD_XYZ_BACKWARD] = TextDrawCreate(94.0000, 347.0000, "txd:transparent");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_BACKWARD], 34.0000, 47.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_BACKWARD], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_BACKWARD], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_BACKWARD], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_BACKWARD], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_BACKWARD], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_BACKWARD], 0);
    TextDrawSetSelectable(g_CreateControlTextDraws[TD_XYZ_BACKWARD], true);

    // Влево
    g_CreateControlTextDraws[TD_XYZ_LEFT] = TextDrawCreate(60.0000, 300.0000, "txd:transparent");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_LEFT], 34.0000, 47.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_LEFT], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_LEFT], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_LEFT], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_LEFT], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_LEFT], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_LEFT], 0);
    TextDrawSetSelectable(g_CreateControlTextDraws[TD_XYZ_LEFT], true);

    // Вправо
    g_CreateControlTextDraws[TD_XYZ_RIGHT] = TextDrawCreate(128.0000, 300.0000, "txd:transparent");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_RIGHT], 34.0000, 47.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_RIGHT], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_RIGHT], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_RIGHT], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_RIGHT], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_RIGHT], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_RIGHT], 0);
    TextDrawSetSelectable(g_CreateControlTextDraws[TD_XYZ_RIGHT], true);

    // Вверх (стрелка вверх для Z-оси)
    g_CreateControlTextDraws[TD_XYZ_UP] = TextDrawCreate(536.0000, 269.0000, "txd:transparent");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_UP], 34.0000, 47.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_UP], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_UP], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_UP], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_UP], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_UP], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_UP], 0);
    TextDrawSetSelectable(g_CreateControlTextDraws[TD_XYZ_UP], true);

    // Вниз (стрелка вниз для Z-оси)
    g_CreateControlTextDraws[TD_XYZ_DOWN] = TextDrawCreate(536.0000, 315.0000, "txd:transparent");
    TextDrawTextSize(g_CreateControlTextDraws[TD_XYZ_DOWN], 34.0000, 47.0000);
    TextDrawAlignment(g_CreateControlTextDraws[TD_XYZ_DOWN], 1);
    TextDrawColor(g_CreateControlTextDraws[TD_XYZ_DOWN], -1);
    TextDrawBackgroundColor(g_CreateControlTextDraws[TD_XYZ_DOWN], 255);
    TextDrawFont(g_CreateControlTextDraws[TD_XYZ_DOWN], 4);
    TextDrawSetProportional(g_CreateControlTextDraws[TD_XYZ_DOWN], 0);
    TextDrawSetShadow(g_CreateControlTextDraws[TD_XYZ_DOWN], 0);
    TextDrawSetSelectable(g_CreateControlTextDraws[TD_XYZ_DOWN], true);
}

stock CreateTextDrawCreateRotation()
{
    g_CreateRotateTextDraws[TD_ROTATION_MAIN] = TextDrawCreate(468.5000, 108.5200, "txd:create_rotation_main");
    TextDrawTextSize(g_CreateRotateTextDraws[TD_ROTATION_MAIN], 136.0000, 315.0000);
    TextDrawAlignment(g_CreateRotateTextDraws[TD_ROTATION_MAIN], 1);
    TextDrawColor(g_CreateRotateTextDraws[TD_ROTATION_MAIN], -1);
    TextDrawBackgroundColor(g_CreateRotateTextDraws[TD_ROTATION_MAIN], 255);
    TextDrawFont(g_CreateRotateTextDraws[TD_ROTATION_MAIN], 4);
    TextDrawSetProportional(g_CreateRotateTextDraws[TD_ROTATION_MAIN], 0);
    TextDrawSetShadow(g_CreateRotateTextDraws[TD_ROTATION_MAIN], 0);
    TextDrawSetSelectable(g_CreateRotateTextDraws[TD_ROTATION_MAIN], true);

    g_CreateRotateTextDraws[TD_ROTATION_X_left] = TextDrawCreate(498.5000, 169.5600, "txd:transparent"); // X_left
    TextDrawTextSize(g_CreateRotateTextDraws[TD_ROTATION_X_left], 36.0000, 39.0000);
    TextDrawAlignment(g_CreateRotateTextDraws[TD_ROTATION_X_left], 1);
    TextDrawColor(g_CreateRotateTextDraws[TD_ROTATION_X_left], -1);
    TextDrawBackgroundColor(g_CreateRotateTextDraws[TD_ROTATION_X_left], 255);
    TextDrawFont(g_CreateRotateTextDraws[TD_ROTATION_X_left], 4);
    TextDrawSetProportional(g_CreateRotateTextDraws[TD_ROTATION_X_left], 0);
    TextDrawSetShadow(g_CreateRotateTextDraws[TD_ROTATION_X_left], 0);
    TextDrawSetSelectable(g_CreateRotateTextDraws[TD_ROTATION_X_left], true);

    g_CreateRotateTextDraws[TD_ROTATION_X_right] = TextDrawCreate(537.5000, 170.1199, "txd:transparent"); // X_right
    TextDrawTextSize(g_CreateRotateTextDraws[TD_ROTATION_X_right], 38.0000, 38.0000);
    TextDrawAlignment(g_CreateRotateTextDraws[TD_ROTATION_X_right], 1);
    TextDrawColor(g_CreateRotateTextDraws[TD_ROTATION_X_right], -1);
    TextDrawBackgroundColor(g_CreateRotateTextDraws[TD_ROTATION_X_right], 255);
    TextDrawFont(g_CreateRotateTextDraws[TD_ROTATION_X_right], 4);
    TextDrawSetProportional(g_CreateRotateTextDraws[TD_ROTATION_X_right], 0);
    TextDrawSetShadow(g_CreateRotateTextDraws[TD_ROTATION_X_right], 0);
    TextDrawSetSelectable(g_CreateRotateTextDraws[TD_ROTATION_X_right], true);

    g_CreateRotateTextDraws[TD_ROTATION_Y_left] = TextDrawCreate(498.5000, 259.1599, "txd:transparent"); // Y_left
    TextDrawTextSize(g_CreateRotateTextDraws[TD_ROTATION_Y_left], 38.0000, 41.0000);
    TextDrawAlignment(g_CreateRotateTextDraws[TD_ROTATION_Y_left], 1);
    TextDrawColor(g_CreateRotateTextDraws[TD_ROTATION_Y_left], -1);
    TextDrawBackgroundColor(g_CreateRotateTextDraws[TD_ROTATION_Y_left], 255);
    TextDrawFont(g_CreateRotateTextDraws[TD_ROTATION_Y_left], 4);
    TextDrawSetProportional(g_CreateRotateTextDraws[TD_ROTATION_Y_left], 0);
    TextDrawSetShadow(g_CreateRotateTextDraws[TD_ROTATION_Y_left], 0);
    TextDrawSetSelectable(g_CreateRotateTextDraws[TD_ROTATION_Y_left], true);

    g_CreateRotateTextDraws[TD_ROTATION_Y_right] = TextDrawCreate(537.0000, 258.0399, "txd:transparent"); // Y_right
    TextDrawTextSize(g_CreateRotateTextDraws[TD_ROTATION_Y_right], 39.0000, 42.0000);
    TextDrawAlignment(g_CreateRotateTextDraws[TD_ROTATION_Y_right], 1);
    TextDrawColor(g_CreateRotateTextDraws[TD_ROTATION_Y_right], -1);
    TextDrawBackgroundColor(g_CreateRotateTextDraws[TD_ROTATION_Y_right], 255);
    TextDrawFont(g_CreateRotateTextDraws[TD_ROTATION_Y_right], 4);
    TextDrawSetProportional(g_CreateRotateTextDraws[TD_ROTATION_Y_right], 0);
    TextDrawSetShadow(g_CreateRotateTextDraws[TD_ROTATION_Y_right], 0);
    TextDrawSetSelectable(g_CreateRotateTextDraws[TD_ROTATION_Y_right], true);

    g_CreateRotateTextDraws[TD_ROTATION_Z_left] = TextDrawCreate(498.0000, 349.3200, "txd:transparent"); // Z_left
    TextDrawTextSize(g_CreateRotateTextDraws[TD_ROTATION_Z_left], 37.0000, 41.0000);
    TextDrawAlignment(g_CreateRotateTextDraws[TD_ROTATION_Z_left], 1);
    TextDrawColor(g_CreateRotateTextDraws[TD_ROTATION_Z_left], -1);
    TextDrawBackgroundColor(g_CreateRotateTextDraws[TD_ROTATION_Z_left], 255);
    TextDrawFont(g_CreateRotateTextDraws[TD_ROTATION_Z_left], 4);
    TextDrawSetProportional(g_CreateRotateTextDraws[TD_ROTATION_Z_left], 0);
    TextDrawSetShadow(g_CreateRotateTextDraws[TD_ROTATION_Z_left], 0);
    TextDrawSetSelectable(g_CreateRotateTextDraws[TD_ROTATION_Z_left], true);

    g_CreateRotateTextDraws[TD_ROTATION_Z_right] = TextDrawCreate(538.0000, 348.7599, "txd:transparent"); // Z_right
    TextDrawTextSize(g_CreateRotateTextDraws[TD_ROTATION_Z_right], 37.0000, 41.0000);
    TextDrawAlignment(g_CreateRotateTextDraws[TD_ROTATION_Z_right], 1);
    TextDrawColor(g_CreateRotateTextDraws[TD_ROTATION_Z_right], -1);
    TextDrawBackgroundColor(g_CreateRotateTextDraws[TD_ROTATION_Z_right], 255);
    TextDrawFont(g_CreateRotateTextDraws[TD_ROTATION_Z_right], 4);
    TextDrawSetProportional(g_CreateRotateTextDraws[TD_ROTATION_Z_right], 0);
    TextDrawSetShadow(g_CreateRotateTextDraws[TD_ROTATION_Z_right], 0);
    TextDrawSetSelectable(g_CreateRotateTextDraws[TD_ROTATION_Z_right], true);
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
   if(l_create[0][H_ID_NET] <= areaid <= l_create[sizeof l_create - 1][H_ID_NET])
   {
      new text[35], id;
      for(new i;i < sizeof l_create;i++)
      {
         if(l_create[i][H_ID_NET] != areaid) continue;
         id = areaid;
         break;
      }
      format(text, sizeof text, "Ты вошел в сферу | ID: %d", l_create[id][H_ID_NET]);
      SendClientMessage(playerid, -1, text);
   }
    #if defined cr_OnPlayerEnterDynamicArea
        return cr_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea cr_OnPlayerEnterDynamicArea
#if defined cr_OnPlayerEnterDynamicArea
    forward cr_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
   if(dialogid == 5011)
   {
      if(response)
      {
          switch(listitem)
          {
            case 0:
            {
              Dialog
              (
                 playerid,5012,DSL,
                 "Помощник в создании | Создание",
                 "Объект\n"\
                 "3D текст\n"\
                 "Актер\n"\
                 "Пикап\n"\
                 "Сфера",
                 "Создать","Назад"
              );
            }
            case 1:
            {
              Dialog
              (
                 playerid,5013,DSL,
                 "Помощник в создании | Удалить",
                 "Объект\n"\
                 "3D текст\n"\
                 "Актер\n"\
                 "Пикап\n"\
                 "Сфера",
                 "Создать","Назад"
              );
            }
            case 2:
            {
              new Float:dist, count, text[256], loading[sizeof (text)+ 25] = {"{FFFFFF}Номер\tServer Id\tТип\tРасстояние\n"};

              for(new s;s < MAX_CREATE;s++)
              {
                 if(l_create[s][H_TYPE] == 0) continue;
                 dist = GetPlayerDistanceFromPoint(playerid, l_create[s][H_X],l_create[s][H_Y],l_create[s][H_Z]);

                 format
                 (
                     text,sizeof text,
                     "{FFFFFF}%d\t{FFFFFF}%d\t{FFFFFF}%s\t{FFFFFF}%.2f\n",
                     s + 1,
                     l_create[s][H_ID_NET],
                     type_create[l_create[s][H_TYPE] - 1],
                     dist
                 );

                 strcat(loading, text);
                 SetPlayerListitemValue(playerid, count ++, s);
              }
              if(!count) return SCM(playerid, -1, "Нет созданных");

              DialogCreate
              (
                 playerid,5014, DIALOG_STYLE_TABLIST_HEADERS,
                 "Помощник в создании | Список созданных",
                 loading,
                 "Создать","Назад"
              );  
            }         
         }
      }
   }
   if(dialogid == 5013)
   {
      if(response)
      {
         switch(listitem)
         {
             case 0:
             {
                new text[256], count, loading[sizeof (text)+ 15] = {"{FFFFFF}Номер\tServer Id\tModel Id\n"};
                for(new n;n < MAX_CREATE;n ++)
                {
                  if(l_create[n][H_TYPE] != H_T_OBJECT) continue;
                  format(text, sizeof text, "{FFFFFF}Объект %d\t{FFFFFF}%d\t{FFFFFF}%d\n", n, l_create[n][H_ID_NET], l_create[n][H_ID_OBJ]);
                  strcat(loading, text);
                  SetPlayerListitemValue(playerid, count, n);
                  count++;
                }
                if(!count) return SCM(playerid, -1, ""USC" Нету созданных объектов");
                DialogCreate
                (
                   playerid, 5020, DIALOG_STYLE_TABLIST_HEADERS,
                   "Помощник | Список объектов",
                   loading,
                   "Удалить", "Назад"
                );
             }
             case 1:
             {
                new text[256], count, loading[sizeof (text)+ 15] = {"{FFFFFF}Номер\tServer Id\tОписание\n"};

                for(new n;n < MAX_CREATE;n ++)
                {
                  if(l_create[n][H_TYPE] != H_T_3DTEXT) continue;
                  format(text, sizeof text, "{FFFFFF}Текст %d\t{FFFFFF}%d\t{FFFFFF}%s\n", n, l_create[n][H_ID_NET], l_create[n][H_STRING]);
                  strcat(loading, text);
                  SetPlayerListitemValue(playerid, count, n);
                  count++;
                }
                  if(!count) return SCM(playerid, -1, ""USC" Нету созданных 3D Текстов");
                DialogCreate
                (
                   playerid, 5021, DIALOG_STYLE_TABLIST_HEADERS,
                   "Помощник | Список 3D текстов",
                   loading,
                   "Удалить", "Назад"
                );
             }
             case 2:
             {
                new text[256], count, loading[sizeof (text)+ 15] = {"{FFFFFF}Номер\tServer Id\tОписание\n"};

                for(new n;n < MAX_CREATE;n ++)
                {
                  if(l_create[n][H_TYPE] != H_T_ACTOR) continue;
                  format(text, sizeof text, "{FFFFFF}Актер %d\t{FFFFFF}%d\t{FFFFFF}%s\n", n, l_create[n][H_ID_NET], l_create[n][H_STRING]);
                  strcat(loading, text);
                  SetPlayerListitemValue(playerid, count, n);
                  count++;
                }
                   if(!count) return SCM(playerid, -1, ""USC" Нету созданных актеров");
                DialogCreate
                (
                   playerid, 5022, DIALOG_STYLE_TABLIST_HEADERS,
                   "Помощник | Список Актеров",
                   loading,
                   "Удалить", "Назад"
                );
             }
             case 3:
             {
                new text[256], count, loading[sizeof (text)+ 15] = {"{FFFFFF}Номер\tServer Id\tModel Id\n"};
                for(new n;n < MAX_CREATE;n ++)
                {
                  if(l_create[n][H_TYPE] != H_T_PICKUP) continue;
                  format(text, sizeof text, "{FFFFFF}Пикап %d\t{FFFFFF}%d\t{FFFFFF}%d\n", n, l_create[n][H_ID_NET], l_create[n][H_ID_OBJ]);
                  strcat(loading, text);
                  SetPlayerListitemValue(playerid, count, n);
                  count++;
                }
                if(!count) return SCM(playerid, -1, ""USC" Нету созданных пикапов");

                DialogCreate
                (
                   playerid, 5023, DIALOG_STYLE_TABLIST_HEADERS,
                   "Помощник | Список пикапов",
                   loading,
                   "Удалить", "Назад"
                );
             }
             case 4:
             {
                new text[256], count, loading[sizeof (text)+ 15] = {"{FFFFFF}Номер\tServer Id\n"};

                for(new n;n < MAX_CREATE;n ++)
                {
                  if(l_create[n][H_TYPE] != H_T_SHPERE) continue;
                  format(text, sizeof text, "{FFFFFF}Сфера %d\t{FFFFFF}%d\n", n, l_create[n][H_ID_NET]);
                  strcat(loading, text);
                  SetPlayerListitemValue(playerid, count, n);
                  count++;
                }

                if(!count) return SCM(playerid, -1, ""USC" Нету созданных сфер");

                DialogCreate
                (
                   playerid, 5024, DIALOG_STYLE_TABLIST_HEADERS,
                   "Помощник | Список сфер",
                   loading,
                   "Удалить", "Назад"
                );
             }
         }
      }
   }
   if(dialogid == 5014)
   {
      if(response)
      {
         new id = GetPlayerListitemValue(playerid, listitem);

         EnablePlayerGPS(playerid, 55, l_create[id][H_X],l_create[id][H_Y],l_create[id][H_Z], "Отмечено на вашей карте");
      }
   }
   if(dialogid == 5020)
   {
      if(response)
      {
         new id = GetPlayerListitemValue(playerid, listitem), string[64];

         DestroyObject(l_create[id][H_ID_NET]);
         l_create[id][H_TYPE] = 0;
         l_create[id][H_ID_NET] = 0;
         l_create[id][H_ID_OBJ] = 0;
         l_create[id][H_X] = 0.0;
         l_create[id][H_Y] = 0.0;
         l_create[id][H_Z] = 0.0;

         format(string, sizeof string, "Объект %d был успешно удален");
         SCM(playerid, -1, string);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5021)
   {
      if(response)
      {
         new id = GetPlayerListitemValue(playerid, listitem), string[64];

         l_create[id][H_TYPE] = 0;
         l_create[id][H_ID_NET] = 0;
         l_create[id][H_ID_OBJ] = 0;
         l_create[id][H_X] = 0.0;
         l_create[id][H_Y] = 0.0;
         l_create[id][H_Z] = 0.0;
         DestroyDynamic3DTextLabel(l_create[id][H_ID_NET_3D]);
         l_create[id][H_ID_NET_3D] = Text3D:0;
         format(string, sizeof string, "3D Текст %d был успешно удален");
         SCM(playerid, -1, string);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5022)
   {
      if(response)
      {
         new id = GetPlayerListitemValue(playerid, listitem), string[64];
         DestroyActor(l_create[id][H_ID_NET]);
         l_create[id][H_TYPE] = 0;
         l_create[id][H_ID_NET] = 0;
         l_create[id][H_ID_OBJ] = 0;
         l_create[id][H_STRING] = 0;
         l_create[id][H_X] = 0.0;
         l_create[id][H_Y] = 0.0;
         l_create[id][H_Z] = 0.0;
         format(string, sizeof string, "Актер %d был успешно удален");
         SCM(playerid, -1, string);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5023)
   {
      if(response)
      {
         new id = GetPlayerListitemValue(playerid, listitem), string[64];
         DestroyPickup(l_create[id][H_ID_NET]);
         l_create[id][H_TYPE] = 0;
         l_create[id][H_ID_NET] = 0;
         l_create[id][H_ID_OBJ] = 0;
         l_create[id][H_X] = 0.0;
         l_create[id][H_Y] = 0.0;
         l_create[id][H_Z] = 0.0;
         format(string, sizeof string, "Пикап %d был успешно удален");
         SCM(playerid, -1, string);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5024)
   {
      if(response)
      {
         new id = GetPlayerListitemValue(playerid, listitem), string[64];
         DestroyDynamicArea(l_create[id][H_ID_NET]);
         l_create[id][H_TYPE] = 0;
         l_create[id][H_ID_NET] = 0;
         l_create[id][H_ID_OBJ] = 0;
         l_create[id][H_X] = 0.0;
         l_create[id][H_Y] = 0.0;
         l_create[id][H_Z] = 0.0;

         format(string, sizeof string, "Cфера %d был успешно удален");
         SCM(playerid, -1, string);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5012)
   {
      if(response)
      {
         switch(listitem)
         {
            case 0:
            {
               Dialog
               (
                  playerid, 5015, DSI,
                  "Помощник в создании | ID Объекта",
                  "Введите ID объекта которого нужно создать\n"\
                  "{FF0000}!{FFFFFF} Будьте осторожно есть объекты из-за которых может\n"\
                  "произойти краш",
                  "Создать", "Назад"
               );
            }
            case 1:
            {
               Dialog
               (
                  playerid, 5016, DSI,
                  "Помощник в создании | Описания 3D текста",
                  "Введите описание для 3D текста",
                  "Создать", "Назад"
               );
            }
            case 2:
            {
               Dialog
               (
                  playerid, 5017, DSI,
                  "Помощник в создании | Создание Актера",
                  "Введите имя для Актера и модель скина\n"\
                  "{FF0000}!{FFFFFF} Пример:Werton, 122",\
                  "Создать", "Назад"
               );
            }
            case 3:
            {
               Dialog
               (
                  playerid, 5018, DSI,
                  "Помощник в создании | ID Модели",
                  "Введите ID модели для пикапа которого нужно создать\n"\
                  "{FF0000}!{FFFFFF} Если вы не знаете какие есть модели найдите в инетрнете,\n"\
                  "при не правильной модели произойдет краш",
                  "Создать", "Назад"
               );
            }
            case 4:
            {
               Dialog
               (
                  playerid, 5019, DSI,
                  "Помощник в создании | Размер сферы",
                  "Введите размер сферы\n"\
                  "{FF0000}!{FFFFFF} Пишите только целое число",
                  "Создать", "Назад"
               );
            }
         }
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5015)
   {
      if(response)
      {
         new id = strval(inputtext), Float:x, Float:y, Float:z;
         if(!strval(inputtext)) return SCM(playerid, -1, ""USC" Ошибка! Некорректный ввод");
         GetPlayerPos(playerid, x, y, z);
         SCM(playerid, -1, ""SC" Через 3 секунды появиться объект");
         set_timer_create[playerid] = SetTimerEx("CreateWelsi", 3000, false, "dddfff", playerid, H_T_OBJECT, id, x, y, z);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5016)
   {
      if(response)
      {
         new id[24], Float:x, Float:y, Float:z;

         if(sscanf(inputtext, "s[24]", id))
         {
            SendClientMessage(playerid, -1, ""USC" Неккорентый ввод");
         }
         printf("id = %s, input = %s", id, inputtext);
         GetPlayerPos(playerid, x, y, z);
         CreateWelsi(playerid, H_T_3DTEXT, 0, x, y, z, inputtext);
         //set_timer_create[playerid] = SetTimerEx("CreateWelsi", 3000, false, "dddfffs", playerid, H_T_3DTEXT, 0, x, y, z, inputtext);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5017)
   {
      if(response)
      {
         
         new id, name[24], Float:x, Float:y, Float:z;

         if(sscanf(inputtext, "P<,>s[24]d", name, id))
         {
            SendClientMessage(playerid, -1, ""USC" Неккорентый ввод");
            return 1;
         }
         printf("name = %s, input = %s", name, inputtext);
         GetPlayerPos(playerid, x, y, z);
         CreateWelsi(playerid, H_T_ACTOR, id, x, y, z, name);
         //set_timer_create[playerid] = SetTimerEx("CreateWelsi", 3000, false, "dddfffs", playerid, H_T_ACTOR, id, x, y, z, inputtext);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5018)
   {
      if(response)
      {
         new id = strval(inputtext), Float:x, Float:y, Float:z;
         if(954 <= id >= 19832) return SCM(playerid, -1, ""USC" Ошибка! Некорректный ввод");
         GetPlayerPos(playerid, x, y, z);
         SCM(playerid, -1, ""SC" Через 3 секунды появиться пикап");
         set_timer_create[playerid] = SetTimerEx("CreateWelsi", 3000, false, "dddfff", playerid, H_T_PICKUP, id, x, y, z);
      }
      else callcmd::create(playerid);
   }
   if(dialogid == 5019)
   {

      if(response)
      {
         new id = strval(inputtext), Float:x, Float:y, Float:z;
         if(0.1 <= id >= 500.0) return SCM(playerid, -1, ""USC" Ошибка! Некорректный ввод");
         GetPlayerPos(playerid, x, y, z);
         SCM(playerid, -1, ""SC" Через 3 секунды появиться сфера");
         set_timer_create[playerid] = SetTimerEx("CreateWelsi", 3000, false, "dddfff", playerid, H_T_SHPERE, id, x, y, z);
      }
      else callcmd::create(playerid);
   }

#if defined cr_OnDialogResponse
return cr_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse cr_OnDialogResponse
#if defined cr_OnDialogResponse
forward cr_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public:CreateWelsi(playerid, type, id, Float:x, Float:y, Float:z, const string[])
{
   new net_id;

   new Text3D:id_3D, id_n = id_cr();

   switch(type)
   {
      case H_T_OBJECT:
      {
         net_id = CreateObject(id, x, y, z, 0.0, 0.0, 0.0);

         l_create[id_n][H_TYPE] = H_T_OBJECT;
         l_create[id_n][H_ID_NET] = net_id;
         l_create[id_n][H_ID_OBJ] = id;
         l_create[id_n][H_X] = x;
         l_create[id_n][H_Y] = y;
         l_create[id_n][H_Z] = z;

         new File:file_create,info[128];

         file_create = fopen("createhelp.txt", io_append);

         format(info,sizeof(info),"CreateObject(%d, %.2f, %.2f, %.2f, 0.0, 0.0, 0.0, 0.0);\r", id, x, y, z);
  		   fwrite(file_create, info);
    	   fclose(file_create);

         new info_obj[100];

     	   SendClientMessage(playerid,-1,"Обьект успешно создан и сохранен в createhelp.txt");
         format(info_obj, sizeof(info_obj), "Серверное айди объекта для редактирования: %d", net_id);
         SendClientMessage(playerid, -1, info_obj);
         print("[W_SYSTEM] createhelp.txt: update!");
      }
      case H_T_3DTEXT:
      {
         l_create[id_n][H_STRING] = '\0';

         strcat(l_create[id_n][H_STRING], string);

         id_3D = CreateDynamic3DTextLabel(l_create[id_n][H_STRING], 0xFFFFFFFF, x, y, z, 10.0);
         
         net_id = _: id_3D;
         l_create[id_n][H_TYPE] = H_T_3DTEXT;
         l_create[id_n][H_ID_NET] = net_id;
         l_create[id_n][H_ID_NET_3D] = id_3D;
         l_create[id_n][H_X] = x;
         l_create[id_n][H_Y] = y;
         l_create[id_n][H_Z] = z;
         new File:file_create,info[128];

         file_create = fopen("createhelp.txt", io_append);

         format(info,sizeof(info),"CreateDynamic3DTextLabel(%s, -1, %.2f, %.2f, %.2f, 10.0, 0);\r", l_create[id_n][H_STRING], x, y, z);
  		   fwrite(file_create, info);
    	   fclose(file_create);

     	   SendClientMessage(playerid,-1,"Сохранено в createhelp.txt");
         print("[W_SYSTEM] createhelp.txt: update!");
      }
      case H_T_ACTOR:
      {
         l_create[id_n][H_STRING] = '\0';
         strcat(l_create[id_n][H_STRING], string);

         net_id = CreateActorEx(l_create[id_n][H_STRING], "", id, x, y, z, 0.0);

         l_create[id_n][H_TYPE] = H_T_ACTOR;
         l_create[id_n][H_ID_NET] = net_id;
         l_create[id_n][H_ID_OBJ] = id;
         l_create[id_n][H_X] = x;
         l_create[id_n][H_Y] = y;
         l_create[id_n][H_Z] = z;

         new File:file_create,info[128];

         file_create = fopen("createhelp.txt", io_append);

         format(info,sizeof(info),"CreateActorEx(%s, "", %d, %.2f, %.2f, %.2f, 0.0);\r",l_create[id_n][H_STRING], id, x, y, z);
  		   fwrite(file_create, info);
    	   fclose(file_create);

     	   SendClientMessage(playerid,-1,"Сохранено в createhelp.txt");
         print("[W_SYSTEM] createhelp.txt: update!");
      }
      case H_T_PICKUP:
      {
         net_id = CreatePickup(id, 23, x, y, z, 0);

         l_create[id_n][H_TYPE] = H_T_PICKUP;
         l_create[id_n][H_ID_NET] = net_id;
         l_create[id_n][H_ID_OBJ] = id;
         l_create[id_n][H_X] = x;
         l_create[id_n][H_Y] = y;
         l_create[id_n][H_Z] = z;

         new File:file_create,info[128];

         file_create = fopen("createhelp.txt", io_append);

         format(info,sizeof(info),"CreatePickup(%d, 23, %.2f, %.2f, %.2f);\r", id, x, y, z);
  		   fwrite(file_create, info);
    	   fclose(file_create);

     	   SendClientMessage(playerid,-1,"Сохранено в createhelp.txt");
         print("[W_SYSTEM] createhelp.txt: update!");
      }
      case H_T_SHPERE:
      {
         net_id = CreateDynamicSphere(x, y, z, float(id));

         l_create[id_n][H_TYPE] = H_T_SHPERE;
         l_create[id_n][H_ID_NET] = net_id;
         l_create[id_n][H_ID_OBJ] = 0;
         l_create[id_n][H_X] = x;
         l_create[id_n][H_Y] = y;
         l_create[id_n][H_Z] = z;

         new File:file_create,info[128];

         file_create = fopen("createhelp.txt", io_append);

         format(info,sizeof(info),"CreateDynamicSphere(%.2f, %.2f, %.2f, %f);\r", x, y, z, float(id));
  		   fwrite(file_create, info);
    	   fclose(file_create);

     	   SendClientMessage(playerid,-1,"Сохранено в createhelp.txt");
         print("[W_SYSTEM] createhelp.txt: update!");
      }
   }
}
stock DialogCreate(playerid, dialogid, style, title[], text[], button[], button2[])
{
  if(style == 5)
  {
     ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "...", "...", "...", ""); 
  }
  ShowPlayerDialog(playerid, dialogid, style, title, text, button, button2);
  return 1;
}

CMD:editobject(playerid, params[])
{
    new object_id;
    if(sscanf(params, "d", object_id))
    {
        SendClientMessage(playerid, -1, "Использование: /editobject [id объекта]");
        return 1;
    }

    new index = -1;
    for(new i = 0; i < MAX_CREATE; i++)
    {
        if(l_create[i][H_TYPE] == H_T_OBJECT && l_create[i][H_ID_NET] == object_id)
        {
            index = i;
            break;
        }
    }

    if(index == -1)
    {
        SendClientMessage(playerid, -1, "Ошибка: Объект с таким ID не найден.");
        return 1;
    }

    tracking_object_id[playerid] = object_id;

    ShowObjectEditingTextDraws(playerid);

    new string[100];
    format(string, sizeof(string), "Вы начали редактирование объекта. ID: %d.", object_id);
    SendClientMessage(playerid, -1, string);
    return 1;
}

stock ShowObjectEditingTextDraws(playerid)
{
   SelectTextDraw(playerid, -1);

	is_editing_object[playerid] = 1;

	for(new i = 0; i < sizeof(g_CreateControlTextDraws); i++)
	{
		TextDrawShowForPlayer(playerid, g_CreateControlTextDraws[i]);
	}
	
	PlayerTextDrawShow(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON]);
   PlayerTextDrawShow(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON]);

	PlayerTextDrawSetString(playerid, g_CreateTypePlayerTextDraws[playerid][0], "txd:create_position");
	PlayerTextDrawShow(playerid, g_CreateTypePlayerTextDraws[playerid][0]);
}

stock HideObjectEditingTextDraws(playerid)
{
   CancelSelectTextDraw(playerid);

	for(new i = 0; i < sizeof(g_CreateControlTextDraws); i++)
	{
		TextDrawHideForPlayer(playerid, g_CreateControlTextDraws[i]);
	}
	
	for(new i = 0; i < sizeof(g_CreateRotateTextDraws); i++)
	{
		TextDrawHideForPlayer(playerid, g_CreateRotateTextDraws[i]);
	}

   PlayerTextDrawHide(playerid, g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON]);
   PlayerTextDrawHide(playerid, g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON]);
	
	PlayerTextDrawHide(playerid, g_CreateTypePlayerTextDraws[playerid][0]);
	is_editing_object[playerid] = 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
   new Float:x, Float:y, Float:z, Float:rotX, Float:rotY, Float:rotZ;

   if(is_editing_object[playerid] >= 1)
   {

    new index = FindObjectArrayIndex(tracking_object_id[playerid]);
    if(index == -1)
    {
        HideObjectEditingTextDraws(playerid);
        SendClientMessage(playerid, -1, "Ошибка: Объект для редактирования не найден.");
        return 1;
    }
    
    GetObjectPos(tracking_object_id[playerid], x, y, z);
    GetObjectRot(tracking_object_id[playerid], rotX, rotY, rotZ);
   }

    if (clickedid == g_CreateControlTextDraws[TD_XYZ_OFF])
    {
        new index = FindObjectArrayIndex(tracking_object_id[playerid]);

        if(index != -1)
        {
            new object_model_id = l_create[index][H_ID_OBJ];

            new File:file_create = fopen("createhelp.txt", io_append);
            new info[256];

            format(info, sizeof(info), "[EDIT] CreateObject(%d, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f);\r\n", 
                object_model_id, x, y, z, rotX, rotY, rotZ);

            fwrite(file_create, info);
            fclose(file_create);
        }
        else
        {
            SendClientMessage(playerid, -1, "Ошибка: Объект не найден в массиве данных. Данные не сохранены.");
        }
        HideObjectEditingTextDraws(playerid);
        SendClientMessage(playerid, -1, "Редактирование объекта завершено. Данные сохранены в файл 'createhelp.txt'.");
    }
    else if(is_editing_object[playerid] == 1) // Кнопки для перемещения объекта (режим 1)
    {
        if(clickedid == g_CreateControlTextDraws[TD_XYZ_FORWARD])
        {
            MoveObject(tracking_object_id[playerid], x, y + 0.1, z, 5.0, rotX, rotY, rotZ);
        }
        else if(clickedid == g_CreateControlTextDraws[TD_XYZ_BACKWARD])
        {
            MoveObject(tracking_object_id[playerid], x, y - 0.1, z, 5.0, rotX, rotY, rotZ);
        }
        else if(clickedid == g_CreateControlTextDraws[TD_XYZ_LEFT])
        {
            MoveObject(tracking_object_id[playerid], x - 0.1, y, z, 5.0, rotX, rotY, rotZ);
        }
        else if(clickedid == g_CreateControlTextDraws[TD_XYZ_RIGHT])
        {
            MoveObject(tracking_object_id[playerid], x + 0.1, y, z, 5.0, rotX, rotY, rotZ);
        }
        else if(clickedid == g_CreateControlTextDraws[TD_XYZ_UP])
        {
            MoveObject(tracking_object_id[playerid], x, y, z + 0.1, 5.0, rotX, rotY, rotZ);
        }
        else if(clickedid == g_CreateControlTextDraws[TD_XYZ_DOWN])
        {
            MoveObject(tracking_object_id[playerid], x, y, z - 0.1, 5.0, rotX, rotY, rotZ);
        }
    }
    else if(is_editing_object[playerid] == 2) // Кнопки для вращения объекта (режим 2)
    {
        if(clickedid == g_CreateRotateTextDraws[TD_ROTATION_X_left])
        {
            MoveObject(tracking_object_id[playerid], x, y, z, 5.0, rotX - 1.0, rotY, rotZ);
        }
        else if(clickedid == g_CreateRotateTextDraws[TD_ROTATION_X_right])
        {
            MoveObject(tracking_object_id[playerid], x, y, z, 5.0, rotX + 1.0, rotY, rotZ);
        }
        else if(clickedid == g_CreateRotateTextDraws[TD_ROTATION_Y_left])
        {
            MoveObject(tracking_object_id[playerid], x, y, z, 5.0, rotX, rotY - 1.0, rotZ);
        }
        else if(clickedid == g_CreateRotateTextDraws[TD_ROTATION_Y_right])
        {
            MoveObject(tracking_object_id[playerid], x, y, z, 5.0, rotX, rotY + 1.0, rotZ);
        }
        else if(clickedid == g_CreateRotateTextDraws[TD_ROTATION_Z_left])
        {
            MoveObject(tracking_object_id[playerid], x, y, z, 5.0, rotX, rotY, rotZ - 1.0);
        }
        else if(clickedid == g_CreateRotateTextDraws[TD_ROTATION_Z_right])
        {
            MoveObject(tracking_object_id[playerid], x, y, z, 5.0, rotX, rotY, rotZ + 1.0);
        }
    }
	
	#if defined cr_OnPlayerClickTextDraw
        return cr_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw cr_OnPlayerClickTextDraw
#if defined cr_OnPlayerClickTextDraw
    forward cr_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == g_CreateTypePlayerTextDraws[playerid][TD_ROTATION_BUTTON])
    {
        if(is_editing_object[playerid] == 1)
        {
            for(new i = 0; i < sizeof(g_CreateControlTextDraws); i++)
            {
                TextDrawHideForPlayer(playerid, g_CreateControlTextDraws[i]);
            }

            // Показываем текстдравы для вращения (глобальные)
            for(new i = 0; i <= TD_ROTATION_Z_right; i++)
            {
               TextDrawShowForPlayer(playerid, g_CreateRotateTextDraws[i]);
            }

            is_editing_object[playerid] = 2;
            PlayerTextDrawSetString(playerid, g_CreateTypePlayerTextDraws[playerid][0], "txd:create_rotation");
            SendClientMessage(playerid, -1, "Режим редактирования: Поворот.");
        }
    }
    else if(playertextid == g_CreateTypePlayerTextDraws[playerid][TD_POSITION_BUTTON])
    {
        if(is_editing_object[playerid] == 2)
        {
            // Скрываем текстдравы для вращения (глобальные)
            for (new i = 0; i <= TD_ROTATION_Z_right; i++)
            {
               TextDrawHideForPlayer(playerid, g_CreateRotateTextDraws[i]);
            }

            for(new i = 0; i < sizeof(g_CreateControlTextDraws); i++)
            {
                TextDrawShowForPlayer(playerid, g_CreateControlTextDraws[i]);
            }
            
            is_editing_object[playerid] = 1;
            PlayerTextDrawSetString(playerid, g_CreateTypePlayerTextDraws[playerid][0], "txd:create_position");
            SendClientMessage(playerid, -1, "Режим редактирования: Позиция.");
        }
    }

   #if defined cr_OnPlayerClickPlayerTextD
		return cr_OnPlayerClickPlayerTextD(playerid, playertextid);
	#else
	    return 1;
	#endif
}
#if defined _ALS_OnPlayerClickPlayerTextD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextD
#endif
#if defined cr_OnPlayerClickPlayerTextD
	forward cr_OnPlayerClickPlayerTextD(playerid, PlayerText:playertextid);
#endif
#define	OnPlayerClickPlayerTextDraw cr_OnPlayerClickPlayerTextD

stock FindObjectArrayIndex(objectid)
{
    for(new i = 0; i < MAX_CREATE; i++)
    {
        if(l_create[i][H_TYPE] == H_T_OBJECT && l_create[i][H_ID_NET] == objectid)
        {
            return i;
        }
    }
    return -1;
}