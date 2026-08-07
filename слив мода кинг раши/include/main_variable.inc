/*
	Оптимизация работы с таймерами
*/

enum E_UNIX_TIMER
{
	TimerID,
	Timer_1,
	Timer_5,
	Timer_10,
	Timer_30,
	Timer_60,
	TimerRandom,
}
new TimerData[E_UNIX_TIMER];

new ServerSpawnCars = -1;

new PlayerFixTimerTazer[MAX_PLAYERS];
new PlayerFixTimerTazerCount[MAX_PLAYERS];

new PlayerFixTimerClearAnim[MAX_PLAYERS];
new PlayerFixTimerClearAnimCount[MAX_PLAYERS];