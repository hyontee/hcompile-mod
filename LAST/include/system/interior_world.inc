// BR — интерьерные virtual world по городу (как филиалы банка)
#if defined _BR_INTERIOR_WORLD_INC_
	#endinput
#endif
#define _BR_INTERIOR_WORLD_INC_

#define BR_INTERIOR_VW_MIN           (2)
#define BR_INTERIOR_VW_MAX           (6)

#define BR_VW_NIZHNY                 (2)
#define BR_VW_LYTKARINO              (3)
#define BR_VW_ARZAMAS                (4)
#define BR_VW_YUZHNY                 (5)
#define BR_VW_BATYREVO               (6)

enum E_BR_CITY_VW_ANCHOR
{
	Float:BR_CAX,
	Float:BR_CAY,
	BR_CAVW
};

static const g_BrCityVWAnchor[][E_BR_CITY_VW_ANCHOR] =
{
	{-2112.2492, 2169.7856, BR_VW_NIZHNY},
	{-2326.8879, -29.0731,  BR_VW_LYTKARINO},
	{394.8446,   762.9340,  BR_VW_ARZAMAS},
	{2376.7722, -2139.3071, BR_VW_YUZHNY},
	{1851.8612,  2037.3320, BR_VW_BATYREVO}
};

stock BR_GetInteriorVWByCoords(Float:x, Float:y)
{
	new best_vw = BR_VW_NIZHNY;
	new Float:best_dist = 99999999.0;

	for(new i = 0; i < sizeof g_BrCityVWAnchor; i++)
	{
		new Float:dx = x - g_BrCityVWAnchor[i][BR_CAX];
		new Float:dy = y - g_BrCityVWAnchor[i][BR_CAY];
		new Float:dist = floatsqroot(dx * dx + dy * dy);
		if(dist < best_dist)
		{
			best_dist = dist;
			best_vw = g_BrCityVWAnchor[i][BR_CAVW];
		}
	}
	return best_vw;
}

stock bool:BR_IsCityInteriorVW(vw)
{
	if(vw < BR_INTERIOR_VW_MIN || vw > BR_INTERIOR_VW_MAX)
		return false;
	for(new i = 0; i < sizeof g_BrCityVWAnchor; i++)
	{
		if(vw == g_BrCityVWAnchor[i][BR_CAVW])
			return true;
	}
	return false;
}

// Бизнес: свой интерьерный мир = ID на сервере (слот 11 ? мир 12, как в метке бизнеса)
stock BR_GetBusinessInteriorVW(businessid)
{
	if(businessid < 0)
		return 0;
	return businessid + 1;
}

stock bool:BR_IsBusinessInteriorVW(vw)
{
	#if defined MAX_BUSINESS
		return (vw >= 1 && vw <= MAX_BUSINESS);
	#else
		return (vw >= 1);
	#endif
}
