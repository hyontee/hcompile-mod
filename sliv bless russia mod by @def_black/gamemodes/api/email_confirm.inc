stock GenerateRandomCode(code[], len) {
    for (new i = 0; i < len - 1; i++) {
        code[i] = '0' + random(10);
    }
    code[len - 1] = '\0';
}

CMD:email(playerid)
{
    if(GetPlayerData(playerid, P_CONFIRM_EMAIL) == true)
    {
        SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}У вас уже привязна электронная почта!");
    }
    else 
    {
        ShowPlayerDialog(playerid, 9912, DIALOG_STYLE_INPUT, "{FF0000}Почта", "Введите вашу действующую электронную почту в окно ниже, на неё будет отправлен код для подтверждения.\n\nПомните, что привязка к электронной почте поможет восстановить пароль от Вашего акккаунта \nв случае взлома или потери доступа к аккаунту!", "Далее", "Выйти");
    }
    return true;
}