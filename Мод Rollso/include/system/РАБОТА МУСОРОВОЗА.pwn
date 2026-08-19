new dvr[4]; 
new checkk[MAX_PLAYERS]; 
new checkk2[MAX_PLAYERS]; 
new checkk3[MAX_PLAYERS]; 
new checkk4[MAX_PLAYERS]; 
new checkk5[MAX_PLAYERS]; 
new checkk7[MAX_PLAYERS]; 
new checkk8[MAX_PLAYERS]; 
new checkk9[MAX_PLAYERS]; 

//КОРДИНАТЫ ИЗМЕНЯТЬ ПОД СЕБЯ *ВАЖНО*

В public OnPlayerStateChange вставляем:
if(newcar >= dvr[0] && newcar <= dvr[3]) 
{ 
        if(ПРОВЕРКА_НА_РАБОТУ)
        { 
                SendClientMessage(playerid, COLOR_GRAD1, "Вы не Мусоровозчик!"); 
                RemovePlayerFromVehicle(playerid); 
        }
}
Выделить и скопировать код

В public OnGameMode вставляем:
dvr[0] = AddStaticVehicle(408, 1668.5034, -1895.3152, 14.0940, 358.0218, 33, 44); // mysorovozka 1 
dvr[1] = AddStaticVehicle(408, 1660.9915, -1894.9308, 14.0979, 0.0745, 33, 44); // mysorovozka 2 
dvr[2] = AddStaticVehicle(408, 1615.6340, -1890.7177, 14.0736, 358.8106, 33, 44); // mysorovozka 3 
dvr[3] = AddStaticVehicle(408, 1622.0182, -1891.0692, 14.0917, 357.5620, 33, 44); // mysorovozka 4  

Create3DTextLabel("{11F43E}Мусоровозчик\n{11E9F4}Для начала Работы введите {FFFFFF}/мусор{FF6600}", COLOR_GREENYELLOW, 1628.9395, -1903.0195, 13.5534, 80.0, 0, 0);





В public OnPlayerEnterCheckpoint вставляем


new vehicleid = GetPlayerVehicleID(playerid);

if(checkk[playerid] == 1) //проверка на чекпоинт 
{
        DisablePlayerCheckpoint(playerid); 
        checkk[playerid] = 1; 
        checkk2[playerid] = 1; 
        SetPlayerCheckpoint(playerid,1536.0526,-1844.1660,13.5469, 4.0); 
        SendClientMessage(playerid,COLOR_YELLOW, "Заберите мусор из {F30F40}Мэрии."); 
        return 1;
} 

if(checkk2[playerid] == 1) //Проверка на Чекпоинт 
{
        if(GetVehicleModel(vehicleid) == 408) 
        {
                DisablePlayerCheckpoint(playerid);//Убираем Когда встаёт на ЧекПоинт 
                checkk2[playerid] = 0; //убирает чекпоинт 
                checkk3[playerid] = 1;//запускаем чекпоинт 
                SetPlayerCheckpoint(playerid,1142.8920,-1328.3668,13.6188, 4.0);//Ваши координаты 
                SendClientMessage(playerid,COLOR_YELLOW, "Заберите мусор из {F30F40}Больницы ЛС"); 
        } 
        else 
        { 
                SendClientMessage(playerid, COLOR_RED, "Возьми машину для работы."); 
        } 
        return 1;
} 

if(checkk3[playerid] == 1) //проверка на чекпоинт 
{
        if(GetVehicleModel(vehicleid) == 408) 
        {
                DisablePlayerCheckpoint(playerid);//Убираем Когда встаёт на ЧекПоинт 
                checkk3[playerid] = 0; //выключает чекпоинт 
                checkk4[playerid] = 1;//запускаем чекпоинт 
                SetPlayerCheckpoint(playerid,379.0806,-2034.0837,7.8301, 5.0);//Ваши координаты 
                SendClientMessage(playerid,COLOR_YELLOW, "Заберите мусор из {F30F40}парка на пирсе."); 
        } 
        else 
        { 
                SendClientMessage(playerid, COLOR_RED, "Возьми машину для работы."); 
        } 
        return 1;
} 

if(checkk4[playerid] == 1) //проверка на чекпоинт 
{
        if(GetVehicleModel(vehicleid) == 408) 
        {
                DisablePlayerCheckpoint(playerid);//Убираем Когда встаёт на ЧекПоинт 
                checkk4[playerid] = 0; //выключает чекпоинт 
                checkk5[playerid] = 1;//запускаем чекпоинт 
                SetPlayerCheckpoint(playerid,-84.6175,-1186.2795,1.7500, 4.0);//Ваши координаты 
                SendClientMessage(playerid,COLOR_YELLOW, "Заберите мусор с {F30F40}заправки."); 
        } 
        else 
        { 
                SendClientMessage(playerid, COLOR_RED, "Возьми машину для работы."); 
        } 
        return 1;
} 
if(checkk5[playerid] == 1) //проверка на чекпоинт 
{
        if(GetVehicleModel(vehicleid) == 408) 
        { 
                DisablePlayerCheckpoint(playerid);//Убираем Когда встаёт на ЧекПоинт 
                checkk5[playerid] = 0; //выключает чекпоинт 
                checkk7[playerid] = 1;//запускаем чекпоинт 
                SetPlayerCheckpoint(playerid,1740.0730,-2287.7793,13.5324, 4.0);//Ваши координаты 
                SendClientMessage(playerid, COLOR_YELLOW, "Заберите мусор из {F30F40}Аэропорта ЛС."); 
        } 
        else 
        { 
                SendClientMessage(playerid, COLOR_RED, "Возьми машину для работы."); 
        } 
        return 1; 
} 

if(checkk7[playerid] == 1) //проверка на чекпоинт 
{
        if(GetVehicleModel(vehicleid) == 408) 
        { 
                DisablePlayerCheckpoint(playerid);//Убираем Когда встаёт на ЧекПоинт 
                checkk7[playerid] = 0; //выключает чекпоинт 
                checkk8[playerid] = 1;//запускаем чекпоинт 
                SetPlayerCheckpoint(playerid,2410.5435,-2474.4304,13.6309, 5.0);//Ваши координаты 
                SendClientMessage(playerid,COLOR_YELLOW, "Отвезите мусор в {F30F40}порт."); 
        } 
        else 
        { 
                SendClientMessage(playerid, COLOR_RED, "Возьми машину для работы."); 
        } 
        return 1; 
}
if(checkk8[playerid] == 1) //проверка на чекпоинт 
{
        if(GetVehicleModel(vehicleid) == 408) 
        { 
                DisablePlayerCheckpoint(playerid);//Убираем Когда встаёт на ЧекПоинт 
                checkk8[playerid] = 0; //выключаем чекпоинт 
                checkk9[playerid] = 1;//запускаем чекпоинт 
                SetPlayerCheckpoint(playerid,1628.9395,-1903.0195,13.5534, 2.0);//Ваши координаты 
                SendClientMessage(playerid,COLOR_YELLOW, "{F0F00B}Отправляйтесь в {F30F40}офис{F0F00B} и заберите свою зарплату."); 
        } 
        else 
        { 
                SendClientMessage(playerid, COLOR_RED, "Вы не выполнили работу!"); 
        } 
        return 1; 
} 
if(checkk9[playerid] == 1)
{
        DisablePlayerCheckpoint(playerid); 
        checkk9[playerid] = 1; 
        new zarplata2 = 1500 + random(600); 
        new rabota[64]; 
        format(rabota, sizeof(rabota), "Вы отвезли мусор и заработали{CC3300} %40", zarplata2); 
        SendClientMessage(playerid, COLOR_ORANGE,rabota); 
        PlayerInfo[playerid][pCash] += zarplata2; 
        return 1;
} 
Выделить и скопировать код





Ну и на конец в public OnPlayerCommandText вставляем:
if(strcmp(cmdtext, "/мусор",true) == 1) 
{ 
        if(ПРОВЕРКА_НА_РАБОТУ)
        {
                SetPlayerCheckpoint(playerid, 1868.2554, -1624.6204, 13.4633, 2.0);
                checkk[playerid] = 1;
                SendClientMessage(playerid,COLOR_YELLOW, "Возьмите мусоровоз и заберите мусор из клуба {F30F40}Альхамбра.");
                return 1;
        }
}