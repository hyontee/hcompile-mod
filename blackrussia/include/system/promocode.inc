stock ShowPromoMenu(playerid)
{
    new menu[512]; // Увеличил размер, так как цвета {FFFFFF} едят много места
    format(menu, sizeof(menu), "Название\tВзаимодействие\n"); // Заголовок
    format(menu, sizeof(menu), "%s{E0584B}#1 {FFFFFF}Активировать промокод\t{C0C0C0}нажмите\n", menu);
    format(menu, sizeof(menu), "%s{E0584B}#2 {FFFFFF}Подарок ютуберу\t{C0C0C0}нажмите\n", menu);
    format(menu, sizeof(menu), "%s{E0584B}#3 {FFFFFF}Создать промокод\t{C0C0C0}нажмите\n", menu);
    format(menu, sizeof(menu), "%s{E0584B}#4 {FFFFFF}Забрать призы\t{C0C0C0}нажмите", menu);

    return ShowPlayerDialog(playerid, DIALOG_PROMO_MAIN, DIALOG_STYLE_TABLIST_HEADERS, 
        "{E0584B}Промокод", menu, "Далее", "Выйти");
}

CMD:promo(playerid, params[])
{
    return ShowPromoMenu(playerid);
}