В этой папке оставлен только патч для ручной правки laird.pwn.

Если не хочешь заменять весь gamemodes/laird.pwn, примени laird_sellcar_govsell.diff вручную:
1. В CMD:sellcar оставь только return UVM_ShowGovSellDialog(playerid);
2. В положительном ответе DIALOG_OWNABLE_CAR_SELL вызови return UVM_SellOwnVehicleToState(playerid);
