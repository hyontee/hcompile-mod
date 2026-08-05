stock GetIDGZ(playerid) {
	for(new i = 0; i < TOTALGZ; i++)
	{
		if(PlayerToKvadrat(playerid,GZInfo[i][gCoords][0], GZInfo[i][gCoords][1],GZInfo[i][gCoords][2],GZInfo[i][gCoords][3])) return i;
	}
	return -1;
}
stock GetGangZoneColor(fractionid) return (GZInfo[fractionid][gFrakVlad] == fBALLAS) ? (0xCC00FFAA) : (GZInfo[fractionid][gFrakVlad] == fRIFA) ? (0x6666FFAA) : (GZInfo[fractionid][gFrakVlad] == fVAGOS) ? (0xffff00AA) : (GZInfo[fractionid][gFrakVlad] == fGROVE) ? (0x009900AA) : (0x00CCFFAA);
stock GetGangColor(g) {
	new zx;
	switch(g) {
		case fGROVE: zx = 0x009900AA;
		case fBALLAS: zx = 0xCC00FFAA;
		case fRIFA: zx = 0x6666FFAA;
		case fAZTEC: zx = 0x00CCFFAA;
		case fVAGOS: zx = 0xffff00AA;
		default: zx = 0xC0C0C0AA;
	}
	return zx;
}
stock gang_name(frac) {
	new namegang[20];
	switch(frac) {
		case fGROVE: namegang = "Grove";
		case fAZTEC: namegang = "Aztecas";
		case fBALLAS: namegang = "Ballas";
		case fRIFA: namegang = "Rifa";
		case fVAGOS: namegang = "Vagos";
	}
	return namegang;
}
stock gang_color(frac) {
	new namegang;
	switch(frac) {
		case fGROVE: namegang = 1017789500;
		case fAZTEC: namegang = 531556863;
		case fBALLAS: namegang = -16711681;
		case fRIFA: namegang = -1378294017;
		case fVAGOS: namegang = -5963521;
	}
	return namegang;
}
stock GFrac(frac) {
	new namegang[20];
	switch(frac) {
		case fGROVE: namegang = "Grove Street";
		case fAZTEC: namegang = "Varrios Los Aztecas";
		case fBALLAS: namegang = "The Ballas";
		case fRIFA: namegang = "The Rifa";
		case fVAGOS: namegang = "Los Santos Vagos";
	}
	return namegang;
}