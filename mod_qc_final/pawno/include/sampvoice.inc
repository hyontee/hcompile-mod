#if defined _sampvoice_included
    #endinput
#endif
#define _sampvoice_included

// Константалар мен Макростар
#define SV_NULL 0
#define SV_FALSE 0
#define SV_TRUE 1
#define SV_INFINITY Float:99999.0

enum SV_GSTREAM { SV_G_NONE }
enum SV_DLSTREAM { SV_DL_NONE }
enum SV_LPSTREAM { SV_LP_NONE }

// Барлық жетіспейтін функциялар (Заглушки)
stock SvInit(...) { return 0; }
stock SvDebug(...) { return 0; }
stock SvCreateGStream(...) { return 0; }
stock SvCreateDLStream(...) { return 0; }
stock SvCreateLPStream(...) { return 0; }
stock SvCreateDLStreamAtPlayer(...) { return 0; }
stock SvAddKey(...) { return 0; }
stock SvHasMicro(...) { return 0; }
stock SvMutePlayer(...) { return 0; }
stock SvUnmutePlayer(...) { return 0; }
stock SvDeleteStream(...) { return 0; }
stock SvAttachListenerToStream(...) { return 0; }
stock SvDetachListenerFromStream(...) { return 0; }
stock SvAttachTargetToStream(...) { return 0; }
stock SvDetachTargetFromStream(...) { return 0; }
stock SvAttachSpeakerToStream(...) { return 0; }
stock SvDetachSpeakerFromStream(...) { return 0; }
stock SvGetVersion(...) { return 0; }
stock SvUpdatePlayerVolume(...) { return 0; }
