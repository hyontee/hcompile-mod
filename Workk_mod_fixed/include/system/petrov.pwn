//к невам

new PlayerText:PetroBG[MAX_PLAYERS];
new PlayerText:PetroText[MAX_PLAYERS];
new PlayerText:PetroYes[MAX_PLAYERS];
new PlayerText:PetroNo[MAX_PLAYERS];
new PlayerText:FadeTD[MAX_PLAYERS];

new bool:PetroShown[MAX_PLAYERS];

//открытие гуишки

stock CreatePetrovichGUI(playerid)
{
    PetroBG[playerid] = CreatePlayerTextDraw(playerid, 320.0, 240.0, "_");
    PlayerTextDrawLetterSize(playerid, PetroBG[playerid], 1.0, 10.0);
    PlayerTextDrawUseBox(playerid, PetroBG[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PetroBG[playerid], 0x000000AA);
    PlayerTextDrawTextSize(playerid, PetroBG[playerid], 450.0, 200.0);
    PlayerTextDrawAlignment(playerid, PetroBG[playerid], 2);

    PetroText[playerid] = CreatePlayerTextDraw(playerid, 320.0, 190.0,
        "Добро пожаловать на сервер~n~Желаешь пройти обучение?");
    PlayerTextDrawAlignment(playerid, PetroText[playerid], 2);
    PlayerTextDrawFont(playerid, PetroText[playerid], 1);
    PlayerTextDrawColor(playerid, PetroText[playerid], -1);

    PetroYes[playerid] = CreatePlayerTextDraw(playerid, 260.0, 260.0, "ДА, ХОЧУ!");
    PlayerTextDrawUseBox(playerid, PetroYes[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PetroYes[playerid], 0x2ECC71FF);
    PlayerTextDrawTextSize(playerid, PetroYes[playerid], 340.0, 30.0);
    PlayerTextDrawSetSelectable(playerid, PetroYes[playerid], true);

    PetroNo[playerid] = CreatePlayerTextDraw(playerid, 350.0, 260.0, "НЕТ, НЕ ХОЧУ!");
    PlayerTextDrawUseBox(playerid, PetroNo[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PetroNo[playerid], 0xE74C3CFF);
    PlayerTextDrawTextSize(playerid, PetroNo[playerid], 450.0, 30.0);
    PlayerTextDrawSetSelectable(playerid, PetroNo[playerid], true);

    FadeTD[playerid] = CreatePlayerTextDraw(playerid, 320.0, 240.0, "_");
    PlayerTextDrawLetterSize(playerid, FadeTD[playerid], 1.0, 30.0);
    PlayerTextDrawUseBox(playerid, FadeTD[playerid], 1);
    PlayerTextDrawBoxColor(playerid, FadeTD[playerid], 0x000000CC);
    PlayerTextDrawTextSize(playerid, FadeTD[playerid], 640.0, 480.0);
    PlayerTextDrawAlignment(playerid, FadeTD[playerid], 2);
}

//хз че то вроде важное

stock ShowPetrovichGUI(playerid)
{
    PlayerTextDrawShow(playerid, PetroBG[playerid]);
    PlayerTextDrawShow(playerid, PetroText[playerid]);
    PlayerTextDrawShow(playerid, PetroYes[playerid]);
    PlayerTextDrawShow(playerid, PetroNo[playerid]);
    SelectTextDraw(playerid, 0xFFFFFFFF);
}

//скрытие гуи

stock HidePetrovichGUI(playerid)
{
    PlayerTextDrawHide(playerid, PetroBG[playerid]);
    PlayerTextDrawHide(playerid, PetroText[playerid]);
    PlayerTextDrawHide(playerid, PetroYes[playerid]);
    PlayerTextDrawHide(playerid, PetroNo[playerid]);
    CancelSelectTextDraw(playerid);
}

//обработка кликов

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if (playertextid == PetroYes[playerid])
    {
        HidePetrovichGUI(playerid);
        StartTraining(playerid);
        return 1;
    }

    if (playertextid == PetroNo[playerid])
    {
        HidePetrovichGUI(playerid);
        SendClientMessage(playerid, 0xAAAAAAFF, "Петрович говорит: Удачи, если что — подходи.");
        return 1;
    }
    return 0;
}

//затемнение экрана

stock StartTraining(playerid)
{
    PlayerTextDrawShow(playerid, FadeTD[playerid]);

    SetTimerEx("TrainingMsg", 1500, false, "i", playerid);
    return 1;
}
forward TrainingMsg(playerid);
public TrainingMsg(playerid)
{
    PlayerTextDrawHide(playerid, FadeTD[playerid]);
    SendClientMessage(playerid, 0x2ECC71FF,
        "Обучение: Арендуй скутер и отправляйся на шахту."
    );
    return 1;
}

//ну и все автор лилхед
