#if defined _BOOM_EXTERNAL_PLUGINS_INC
    #endinput
#endif
#define _BOOM_EXTERNAL_PLUGINS_INC

// Compatibility declarations for the plugins used by shanyrak.pwn.
// These declarations are intentionally limited to symbols referenced by this source.

// SA-MP MySQL
native mysql_log(...);
native mysql_close(...);
native mysql_errno(...);
native mysql_format(...);
native mysql_query(...);
native mysql_stat(...);
native mysql_tquery(...);
native cache_affected_rows(...);
native cache_delete(...);
native cache_get_data(...);
native cache_get_field_content(...);
native cache_get_field_content_float(...);
native cache_get_field_content_int(...);
native cache_get_field_count(...);
native cache_get_row(...);
native cache_get_row_count(...);
native cache_num_rows(...);
native cache_get_row_int(...);
native cache_insert_id(...);
native cache_is_valid(...);
native cache_save(...);
native cache_set_active(...);

// sscanf
native sscanf(const data[], const format[], {Float,_}:...);

// Streamer
native CreateDynamic3DTextLabel(...);
native CreateDynamicActor(...);
native CreateDynamicCP(...);
native CreateDynamicCircle(...);
native CreateDynamicMapIcon(...);
native CreateDynamicObject(...);
native CreateDynamicPickup(...);
native CreateDynamicRaceCP(...);
native CreateDynamicRectangle(...);
native CreateDynamicSphere(...);
native DestroyDynamic3DTextLabel(...);
native DestroyDynamicArea(...);
native DestroyDynamicCP(...);
native DestroyDynamicMapIcon(...);
native DestroyDynamicObject(...);
native DestroyDynamicPickup(...);
native DestroyDynamicRaceCP(...);
native Streamer_Update(...);

#endif
