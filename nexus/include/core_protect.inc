/*
	core_protect.inc
	----------------
	Служебный файл ядра гейммода. Без него компиляция невозможна:
	отсутствие GetPlayerData/SetPlayerData вызовет цепную реакцию из
	тысяч ошибок "undefined symbol" во всех модулях, где к ним идёт
	обращение (напрямую или через производные макросы — GetPlayerNameEx,
	GetPlayerAccountID, GetPlayerLevel и т.д.)

	Не удалять, не переименовывать, не выкладывать отдельно от проекта.
*/

#if defined _core_protect_included
	#endinput
#endif
#define _core_protect_included

#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif
#define MAX_PLAYERS (150)

// Ключевые макросы доступа к данным игрока.
// Используются напрямую и через производные макросы (GetPlayerNameEx,
// GetPlayerAccountID, GetPlayerLevel и т.д.) более 2000 раз по всему коду.
// Без этого файла компилятор не найдёт GetPlayerData/SetPlayerData —
// и абсолютно все модули, где к ним идёт обращение, посыплются
// ошибками "undefined symbol".
#define GetPlayerData(%0,%1) 	g_player[%0][%1]
#define SetPlayerData(%0,%1,%2)	g_player[%0][%1] = %2
