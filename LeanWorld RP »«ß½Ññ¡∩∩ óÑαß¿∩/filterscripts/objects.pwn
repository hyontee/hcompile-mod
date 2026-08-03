#pragma warning disable 239
#pragma warning disable 214
#include <a_samp>
#include <streamer>
#include <fixobject>

public OnFilterScriptInit()
{
	new tmpobjid, gHouseInter[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}, fso_map;
	
	#include </mapping/weazel>
	#include </mapping/LoadFBI>
	#include </mapping/LoadPravo>
	#include </mapping/LoadObject>
	#include </mapping/LoadObjectEx>
	#include </mapping/LoadGhettoInteriors>
	#include </mapping/LoadGarage>
	#include </mapping/LoadTrailer>
	#include </mapping/LoadExteriorMaria>
	#include </mapping/LoadAutoshool>
	#include </mapping/LoadTuning>
	#include </mapping/LoadRussianMafia>
	#include </mapping/LoadYakuza>
	#include </mapping/LoadHospital>
	#include </mapping/LoadPolice>
	#include </mapping/LoadJail>
	#include </mapping/LoadLCN>
	#include </mapping/LoadAutoe>
	#include </mapping/halloween>
	
    tmpobjid = CreateDynamicObject(1256, 1141.489013, -1757.459594, 13.233742, 0.000000, -0.000007, 179.999954, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "grey_carpet_256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14853, "gen_pol_vegas", "grey_carpet_256", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 1141.489013, -1753.596313, 13.233742, 0.000000, -0.000007, 179.999954, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "grey_carpet_256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14853, "gen_pol_vegas", "grey_carpet_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19476, 1141.268798, -1757.465454, 13.356040, 0.000000, -12.300008, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "No smoking", 120, "Arial", 100, 1, 0xFF000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19476, 1141.275878, -1756.794799, 13.367849, 0.000000, -12.000007, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "z", 120, "Webdings", 130, 1, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19476, 1141.268798, -1753.712524, 13.356040, 0.000000, -12.299994, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "No smoking", 120, "Arial", 100, 1, 0xFF000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19476, 1141.275878, -1753.041870, 13.367849, 0.000000, -11.999993, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "z", 120, "Webdings", 130, 1, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(9833, 1137.511474, -1755.564575, 9.572624, 0.000000, -1.199998, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9582, "fort_sfw", "mallfloor2", 0x00000000);
	tmpobjid = CreateDynamicObject(9833, 1136.410766, -1755.564575, 9.548622, 0.699998, -0.099996, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9582, "fort_sfw", "mallfloor2", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1140.937255, -1751.186767, 12.527018, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1164.928710, -1751.186767, 12.527018, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(7922, 1107.842163, -1751.840820, 12.270060, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(1215, 1164.950317, -1782.450073, 13.129396, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1780.256713, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1776.142333, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1772.021240, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1767.901000, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1763.771362, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1759.651123, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1755.537719, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1164.994506, -1753.445678, 13.040316, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1130.650146, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1215, 1164.940307, -1751.278076, 13.139395, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1126.520141, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1141.010864, -1757.619750, 13.040316, 0.000007, 0.000000, 89.999977, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1141.010864, -1755.537719, 13.040316, 0.000007, 0.000000, 89.999977, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1141.010864, -1753.445678, 13.040315, 0.000007, 0.000000, 89.999977, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1215, 1140.986694, -1759.841552, 13.139395, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1444, 1140.140014, -1759.741210, 13.384077, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1137.388183, -1759.910034, 13.040316, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1215, 1135.188110, -1759.911621, 13.139395, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1135.216308, -1762.038940, 13.040316, 0.000007, 0.000000, -89.000038, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1135.247070, -1764.129638, 13.040316, 0.000007, 0.000000, -89.000038, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1215, 1135.258178, -1766.271850, 13.139395, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19425, 1164.722167, -1738.337646, 12.473855, 0.000000, -2.400000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19425, 1164.752197, -1743.459838, 12.369491, 0.000000, -0.200000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1257, 1167.426513, -1768.808105, 13.738441, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1350, 1162.158935, -1746.370727, 12.517466, 0.000000, 0.000000, 270.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1216, 1145.781982, -1763.474365, 13.239519, 0.000000, 0.000000, 270.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1216, 1145.781982, -1765.206054, 13.239519, 0.000000, 0.000000, 270.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1138.525024, -1753.077148, 10.968901, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1136.474975, -1753.075195, 10.971902, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1133.156494, -1754.810546, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1128.296386, -1753.019531, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1129.767089, -1759.160400, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1125.126953, -1756.878784, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1122.817016, -1752.389160, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1122.817016, -1762.911254, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1133.147583, -1762.911254, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1126.816406, -1762.130493, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1118.976074, -1754.969970, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1120.586669, -1758.979736, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1116.836181, -1766.660522, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1114.525268, -1774.221435, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1111.904907, -1769.451416, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1108.624023, -1777.192138, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1103.533325, -1784.612670, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1109.464599, -1764.231445, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1112.985961, -1760.931030, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1117.406005, -1762.111083, 12.714563, 0.000000, 0.000000, -41.900009, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1116.166381, -1758.192749, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1108.464843, -1758.192749, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(870, 1112.024780, -1754.481933, 12.714563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1134.958251, -1754.766357, 10.968901, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1140.043457, -1754.766357, 10.968901, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1140.045410, -1756.588134, 10.970903, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1131.694213, -1759.765502, 11.568902, 0.000000, 0.000000, 175.099929, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1128.863769, -1754.735107, 11.568902, 0.000000, 0.000000, 175.099929, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1123.581176, -1754.729125, 11.568902, 0.000000, 0.000000, 160.899932, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1125.307617, -1759.432739, 11.568902, 0.000000, 0.000000, 160.899932, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1128.070922, -1764.167968, 11.568902, 0.000000, 0.000000, 160.899932, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1122.173217, -1763.675537, 11.568902, 0.000000, 0.000000, 101.899894, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1121.892211, -1758.692626, 11.568902, 0.000000, 0.000000, -95.900123, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1118.534912, -1754.509643, 11.568902, 0.000000, 0.000000, 118.299888, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1112.921752, -1755.158813, 11.568902, 0.000000, 0.000000, 118.299888, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1115.814331, -1760.529296, 11.568902, 0.000000, 0.000000, 118.299888, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1117.445434, -1764.600830, 11.568902, 0.000000, 0.000000, -24.000101, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1114.049316, -1762.246093, 11.568902, 0.000000, 0.000000, -24.000101, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1111.708251, -1758.160644, 11.568902, 0.000000, 0.000000, 85.399879, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1109.657348, -1759.845092, 11.568902, 0.000000, 0.000000, 46.399887, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1109.298950, -1753.567504, 11.568902, 0.000000, 0.000000, 46.399887, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1108.899047, -1763.041015, 11.788894, 0.000000, 0.000000, 15.199884, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1111.058715, -1768.250488, 11.898897, 0.000000, 0.000000, -40.800144, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1115.430053, -1769.959838, 11.898897, 0.000000, 0.000000, 29.099859, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1117.019409, -1775.174316, 11.898897, 0.000000, 0.000000, -19.100141, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1116.822021, -1779.721801, 12.288898, 0.000000, 0.000000, -95.100143, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1110.087646, -1778.146240, 12.328906, 0.000000, 0.000000, 54.599868, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1110.819946, -1773.145263, 12.328906, 0.000000, 0.000000, 54.599868, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1104.288940, -1784.396728, 12.328906, 0.000000, 0.000000, -33.000129, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1133.075927, -1763.410278, 11.568902, 0.000000, 0.000000, -164.900100, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19603, 1137.543090, -1755.610229, 12.671999, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1134.960205, -1756.587890, 10.970903, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1136.474975, -1758.105712, 10.968901, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19367, 1138.498413, -1758.107666, 10.966900, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(826, 1132.310180, -1755.030761, 11.568902, 0.000000, 0.000000, 175.099929, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1138.930908, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1134.781005, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1122.399780, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1118.279174, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1114.148681, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1110.008300, -1750.865600, 13.040315, 0.000007, 0.000000, 179.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1106.727905, -1754.915893, 13.040315, 0.000007, 0.000000, 269.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1106.727905, -1759.035766, 13.040315, 0.000007, 0.000000, 269.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1106.727905, -1763.175659, 13.040315, 0.000007, 0.000000, 269.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1106.727905, -1767.305786, 13.040315, 0.000007, 0.000000, 269.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1106.727905, -1771.435791, 13.040315, 0.000007, 0.000000, 269.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1106.727905, -1775.566040, 13.040315, 0.000007, 0.000000, 269.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(970, 1106.727905, -1779.706176, 13.040315, 0.000007, 0.000000, 269.999969, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11711, 1139.466308, -1762.454589, 15.817960, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1549, 1141.265380, -1751.946289, 12.578363, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1549, 1141.265380, -1759.365478, 12.578363, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);

	//  ÓÌÚÂÈÌÂ˚
	new kontsmapers;
	kontsmapers = CreateDynamicObject(11293, 1418.346069, -2208.101074, 18.046861, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontsmapers, 0, -1, "none", "none", 0xFFFFFFFF);
	kontsmapers = CreateDynamicObject(3571, 1446.265136, -2208.868896, 13.876860, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontsmapers, 0, -1, "none", "none", 0xFFFFFFFF);
	kontsmapers = CreateDynamicObject(2935, 1428.541503, -2208.350341, 13.946874, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontsmapers, 0, -1, "none", "none", 0xFFFFFFFF);
	kontsmapers = CreateDynamicObject(8886, 1436.746337, -2209.649902, 15.886861, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontsmapers, 0, -1, "none", "none", 0xFFFFFFFF);
	kontsmapers = CreateDynamicObject(19589, 1462.180664, -2207.529296, 13.526868, 180.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontsmapers, 0, 5710, "cemetery_law", "brickgrey", 0x00000000);
	kontsmapers = CreateDynamicObject(19589, 1462.180664, -2209.777587, 13.526868, 180.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontsmapers, 0, 5710, "cemetery_law", "brickgrey", 0x00000000);
	kontsmapers = CreateDynamicObject(355, 1462.055053, -2209.271972, 13.567755, -82.000030, 40.000011, 6.099998, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(kontsmapers, 0, 19962, "samproadsigns", "greenbackgroundsign", 0x00000000);
	kontsmapers = CreateDynamicObject(19477, 1465.082397, -2209.156005, 14.786880, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(kontsmapers, 0, " ŒÕ“≈…Õ≈–€", 140, "Arial", 40, 1, 0xFFFFFFFF, 0x00000000, 1);
	kontsmapers = CreateDynamicObject(19477, 1437.277465, -2214.481933, 18.826904, 0.000000, 0.000000, 270.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(kontsmapers, 0, "BEST", 130, "Courier New", 90, 1, 0xFFFFFFFF, 0x00000000, 1);
	kontsmapers = CreateDynamicObject(19477, 1437.327514, -2214.471923, 18.826904, 0.000000, 0.000000, 270.000000, object_world, object_int, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(kontsmapers, 0, "BEST", 130, "Courier New", 90, 1, 0xFF000000, 0x00000000, 1);
	CreateDynamicObject(1339, 1436.081176, -2221.152343, 13.166876, 0.000000, 0.000000, 96.300003, object_world, object_int, -1, 300.00, 300.00);
	CreateDynamicObject(1550, 1462.164062, -2208.152343, 13.537075, 52.499996, 3.500000, 4.699999, object_world, object_int, -1, 300.00, 300.00);
	CreateDynamicObject(2840, 1462.250000, -2207.129394, 13.506866, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	CreateDynamicObject(2860, 1461.635620, -2210.423095, 13.510563, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
	CreateDynamicObject(19980, 1465.043823, -2209.149414, 12.196869, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00);
	return true;
}
