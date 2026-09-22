//>> Файл: bykranin_src/systems/m1stoks/larek/headers.inc  (57 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: g_larek_static_positions, g_larek_area, g_larek_item_price, g_larek_item_satiety
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/larek/headers.inc
#if defined _m1stoks_headers_included
	#endinput
#endif
#define _m1stoks_headers_included

#define LAREK_AREA_RANGE                (2.0)
#define LAREK_INTERACT_RANGE            (2.0)
#define LAREK_ITEM_COUNT                (6)
#define LAREK_NOTIFY_COOLDOWN_MS        (1500)
#define LAREK_NOTIFY_ID                 (62)
#define LAREK_STATIC_PRICE             (500000)
#define LAREK_STATIC_RENT_PRICE        (5000)
#define LAREK_STATIC_PRODUCTS          (10000)
#define LAREK_STATIC_INTERIOR          (0)
#define LAREK_STATIC_FIND_RANGE        (2.0)

new const Float:g_larek_static_positions[][3] =
{
	{-113.201, 942.369, 12.2141},
	{-111.83, 905.018, 12.2142},
	{57.9155, 942.644, 12.2129},
	{154.984, 586.486, 12.2141},
	{-256.276, 573.732, 12.195},
	{-2402.3, 194.55, 26.0326},
	{1801.86, 2531.64, 14.6583},
	{1905.67, 2104.01, 15.7135},
	{2744.2, -2429.01, 21.8987},
	{2283.69, -2171.79, 22.0376},
	{2251.62, -2110.84, 22.0376},
	{1912.64, -2266.77, 11.0912},
	{1889.19, -2243.52, 11.0754},
	{847.375, 802.654, 13.3786},
	{-2322.84, -150.564, 26.5272},
	{-1760.46, 790.768, 35.7447},
	{-2638.4, 2002.19, 9.64933},
	{-2146.13, 1598.92, 9.88}
};

new g_larek_area[MAX_BUSINESS] = {STREAMER_TAG_AREA:-1, ...};

new const g_larek_item_price[LAREK_ITEM_COUNT] =
{
	120, 230, 320, 580, 80, 30
};

new const g_larek_item_satiety[LAREK_ITEM_COUNT] =
{
	8, 15, 21, 39, 5, 2
};

new
	p_larek_biz_id[MAX_PLAYERS] = {-1, ...},
	p_larek_notify_biz[MAX_PLAYERS] = {-1, ...},
	p_larek_last_check_ms[MAX_PLAYERS];
// END INLINED: modules/m1stoks/larek/headers.inc
