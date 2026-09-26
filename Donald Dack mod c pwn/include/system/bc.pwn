										ко всем нью


new bschel;
new bsvz;


										ко всем идам
										
										
// ------------------------
DIALOG_BSSTART,
DIALOG_BSOKNODVA,
DIALOG_BSOKNOTRI,
DIALOG_BSOKNOCHETIRE,
DIALOG_BSOKNOPYAT,
DIALOG_BSOKNOSHEST,
// ------------------------
										
										


										
										
										public OnGameModeInit
										
bschel = CreatePickup(1314, 23, -40.731002, 1361.520751, 12.879920, 0);
	Create3DTextLabel("{FFFF00}<< Регестрация битвы семей >>", 0xFFFFFFFF, -40.731002, 1361.520751, 12.879920, 3);
	bsvz = CreateDynamicSphere(-40.731002, 1361.520751, 12.879920, 0.8, 0, 0, -1);
										
										
										
										
										public OnDialogResponse
										
if(dialogid == DIALOG_BSCREATE)
	{
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNODVA,  DIALOG_STYLE_LIST, "{FF0000}Вооружение первое", "{FF0000}1. {FFFFFF}Deagle\n\
				{FF0000}2. {FFFFFF}ShotGun\n\
				{FF0000}3. {FFFFFF}Rifle\n\
				{FF0000}4. {FFFFFF}M4A1", "Далее", "Выйти");
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_BSOKNODVA)
	{
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOTRI,  DIALOG_STYLE_LIST, "{FF0000}Вооружение второе", "{FF0000}1. {FFFFFF}Deagle\n\
				{FF0000}2. {FFFFFF}ShotGun\n\
				{FF0000}3. {FFFFFF}Rifle\n\
				{FF0000}4. {FFFFFF}M4A1", "Далее", "Выйти");
			}
			else if(listitem == 1)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOTRI,  DIALOG_STYLE_LIST, "{FF0000}Вооружение второе", "{FF0000}1. {FFFFFF}Deagle\n\
				{FF0000}2. {FFFFFF}ShotGun\n\
				{FF0000}3. {FFFFFF}Rifle\n\
				{FF0000}4. {FFFFFF}M4A1", "Далее", "Выйти");
			}
			else if(listitem == 2)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOTRI,  DIALOG_STYLE_LIST, "{FF0000}Вооружение второе", "{FF0000}1. {FFFFFF}Deagle\n\
				{FF0000}2. {FFFFFF}ShotGun\n\
				{FF0000}3. {FFFFFF}Rifle\n\
				{FF0000}4. {FFFFFF}M4A1", "Далее", "Выйти");
			}
			else if(listitem == 3)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOTRI,  DIALOG_STYLE_LIST, "{FF0000}Вооружение второе", "{FF0000}1. {FFFFFF}Deagle\n\
				{FF0000}2. {FFFFFF}ShotGun\n\
				{FF0000}3. {FFFFFF}Rifle\n\
				{FF0000}4. {FFFFFF}M4A1", "Далее", "Выйти");
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_BSOKNOTRI)
	{
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOCHETIRE,  DIALOG_STYLE_LIST, "{FF0000}Ставка", "{FF0000}1. {FFFFFF}Репутация\n\
				{FF0000}2. {FFFFFF}Деньги", "Далее", "Выйти");
			}
			else if(listitem == 1)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOCHETIRE,  DIALOG_STYLE_LIST, "{FF0000}Ставка", "{FF0000}1. {FFFFFF}Репутация\n\
				{FF0000}2. {FFFFFF}Деньги", "Далее", "Выйти");
			}
			else if(listitem == 2)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOCHETIRE,  DIALOG_STYLE_LIST, "{FF0000}Ставка", "{FF0000}1. {FFFFFF}Репутация\n\
				{FF0000}2. {FFFFFF}Деньги", "Далее", "Выйти");
			}
			else if(listitem == 3)
			{
				ShowPlayerDialog(playerid, DIALOG_BSOKNOCHETIRE,  DIALOG_STYLE_LIST, "{FF0000}Ставка", "{FF0000}1. {FFFFFF}Репутация\n\
				{FF0000}2. {FFFFFF}Деньги", "Далее", "Выйти");
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_BSOKNOCHETIRE)
	{
		if(response)
		{
			if(listitem == 0)
			{
       			ShowPlayerDialog(playerid, DIALOG_BSOKNOPYAT,  DIALOG_STYLE_INPUT, "{FF0000}Ставка", "{FFFFFF}Чтобы зарегистрироваться, нужно сделать взнос репутации(минимально 50, максимально 5000)", "Далее", "Выйти");
			}
			else
			{
			    SendCleinMessage(playerid, COLOR_WHITE, "нет")
			}
			else if(listitem == 1)
			{
			    ShowPlayerDialog(playerid, DIALOG_BSOKNOPYAT,  DIALOG_STYLE_INPUT, "{FF0000}Ставка", "{FFFFFF}Чтобы зарегистрироваться, нужно сделать денежный взнос(минимально 20000, максимально 3000000)", "Далее", "Выйти");
			}
			else
			{
			    SendCleinMessage(playerid, COLOR_WHITE, "нет")
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_BSOKNOPYAT)
	{
		if(response)
		{
			if(listitem == 0)
			{
			    ShowPlayerDialog(playerid, DIALOG_BSOKNOSHEST,  DIALOG_STYLE_INPUT, "{FF0000}Количество", "Введите количество человек которое будет сражаться за Вашу семью(минимвально 5, максимально 15)", "Далее", "Выйти");
			}
			else
			{
			    SendCleinMessage(playerid, COLOR_WHITE, "нет")
			}
			else if(listitem == 1)
			{
                ShowPlayerDialog(playerid, DIALOG_BSOKNOSHEST,  DIALOG_STYLE_INPUT, "{FF0000}Количество", "Введите количество человек которое будет сражаться за Вашу семью(минимвально 5, максимально 15)", "Далее", "Выйти");
			}
			else
			{
			    SendCleinMessage(playerid, COLOR_WHITE, "нет")
			}
		}
		return 1;
	}	return 1;
	}

										
										
										
										
										
										OnPlayerEnterDynamicArea
										
										
										
if (areaid == bsvz) {
    ShowPlayerDialog(playerid, DIALOG_BSCREATE,  DIALOG_STYLE_LIST, "{FF0000}Битва семей", "Создать новое состязание", "Далее", "Выйти");
    return 1;
 }
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										

