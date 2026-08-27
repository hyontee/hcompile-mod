/*--------[Launcher]--------*/
native SetLauncherStatus(playerid, bool:status);//Устанавливает статус лаунчера игрока. Если указан true, то у игрока будут работать авто, CEF вызовы и другие функции лаунчера.
native GetLauncherStatus(playerid);//Возвращает статус лаунчера игрока.

/*--------[Custom Skins Models]--------*/
forward GetLauncherSkinModel(current_model);
public GetLauncherSkinModel(current_model)
{
	new model = -1;
	switch(current_model)
	{
	    case 312: model = 296;
	    case 313: model = 230;
	    case 908: model = 200;
		
	}
	return model;
}
/*--------[Custom Vehicles Models]--------*/
forward GetLauncherVehicleModel(current_model);
public GetLauncherVehicleModel(current_model)
{
	new model = -1;
	switch(current_model)
	{
	    // case 612: model = 541;
	    // case 613: model = 451;
	    // case 614: model = 411;
		// case 662: model = 400;
		// case 668: model = 541;
		// case 1196: model = 451;
		// case 3194: model = 522;

	}
	return model;
}

