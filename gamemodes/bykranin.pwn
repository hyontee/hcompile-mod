//>> ============================================================================
//>> bykranin.pwn - главный файл мода (только настройки, библиотеки и список модулей).
//>> Весь код лежит в gamemodes/bykranin_src/ ; порядок #include ВАЖЕН, не менять.
//>> Карта модулей: gamemodes/bykranin_src/MODULES.md
//>> ============================================================================
#pragma dynamic 131072

#pragma warning disable 239
#pragma warning disable 214
#pragma warning disable 202
#pragma warning disable 203
#pragma warning disable 213
#pragma warning disable 234
#pragma warning disable 216
#pragma warning disable 219
#pragma warning disable 209
#pragma warning disable 202
#pragma warning disable 201
#pragma warning disable 225
#pragma warning disable 200  
#pragma warning disable 211
#pragma warning disable 204
#pragma warning disable 201
#pragma warning disable 208
#pragma warning disable 215
#pragma warning disable 235
#pragma warning disable 217
#pragma warning disable 212
#pragma warning disable 228
#pragma warning disable 205
#include <a_samp>

// Server configs use at most 200 slots; avoid allocating every per-player array for SA-MP's default 1000.
#undef MAX_PLAYERS
#define MAX_PLAYERS (200)

// Compatibility stubs: the diner module is absent from this source package.
stock Diner_IsEnterPosition(Float:x, Float:y, Float:z)
{
    #pragma unused x, y, z
    return 0;
}

stock Diner_UpdateBusinessEnterLabel(Float:x, Float:y, Float:z, businessid, const owner_name[])
{
    #pragma unused x, y, z, businessid, owner_name
    return 0;
}

stock Diner_HandleBuyCommand(playerid)
{
    #pragma unused playerid
    return 0;
}
#include <a_http>

// -- mx.txt
#include <mxINI>

// -- include
#include "../include/a_mysql.inc"
#include "../include/Pawn.CMD.inc" // -- старое гавно, но нада
#include "../include/Pawn.RakNet.inc" // -- еще хуже чем гавно лол
#include "../include/streamer.inc"
#include "../include/sscanf2.inc"
#include "../include/foreach.inc"
#include "../include/lib/m_crzones.inc"
#include "../include/lib/m_dialog.inc"
#include "../include/mxdate.inc"
#include "../include/fdialog.inc"
#include "../include/fly.inc"

#include "../include/json.inc"

// -- system
//>> ---- systems ----
#include "bykranin_src/systems/cp.pwn"
#include "bykranin_src/systems/cp_race.pwn"
#include "bykranin_src/systems/pickup.pwn"
#include "bykranin_src/systems/vehicle.pwn"

#include <voicechat> // -- от вайновских олд

//#include <pawncmd> // -- новое
#include <pawnraknet> // -- fix
#include "bykranin_src/systems/trunk_weights_generated.inc"
//>> ---- core/decl ----
#include "bykranin_src/core/decl/globals_01.inc"
//>> ---- systems ----
#include "bykranin_src/systems/contnewsystem/contnewsystem.pwn"
//>> ---- core/decl ----
#include "bykranin_src/core/decl/globals_02.inc"
#include "bykranin_src/core/decl/globals_03.inc"
#include "bykranin_src/core/decl/enums_01.inc"
#include "bykranin_src/core/decl/enums_02.inc"
#include "bykranin_src/core/decl/globals_04.inc"
#include "bykranin_src/core/decl/funcs_01.inc"
//>> ---- systems ----
#include "bykranin_src/systems/blackjack_full.pwn"
//>> ---- core/decl ----
#include "bykranin_src/core/decl/globals_05.inc"
#include "bykranin_src/core/decl/globals_06.inc"
//>> ---- systems ----
#include "bykranin_src/systems/carshare_welsi.pwn"
#include "bykranin_src/systems/exchange_welsi.pwn"
#include "bykranin_src/systems/inventory_skin.pwn"
#include "bykranin_src/systems/family.pwn"
#include "bykranin_src/systems/family_addition.pwn"
#include "bykranin_src/systems/familysystem.inc"
#include "bykranin_src/systems/weekly_prizes.pwn"
#include "bykranin_src/systems/orel_reshka.pwn"
#include "bykranin_src/systems/accessory.pwn"
//>> ---- core/jobs ----
#include "bykranin_src/core/jobs/jobs_01.inc"
//>> ---- systems ----
#include "bykranin_src/systems/core/admin/xcbgs.pwn"
// headers
//#include "../gamemodes/modules/core/admin/headers.inc"
#include "bykranin_src/systems/core/vehicle/auto-race/headers.inc"

// callbacks
//#include "../gamemodes/modules/core/admin/callbacks.pwn"
#include "bykranin_src/systems/core/vehicle/auto-race/callbacks.pwn"

// commands
//#include "../gamemodes/modules/core/admin/commands.pwn"

// dialogs
//#include "../gamemodes/modules/core/admin/dialogs.pwn"
#include "bykranin_src/systems/core/vehicle/auto-race/dialogs.pwn"
#include "bykranin_src/systems/core/admin/heajsa.pwn"
//>> ---- core/admin ----
#include "bykranin_src/core/admin/admin_01.inc"
//>> ---- core/data ----
#include "bykranin_src/core/data/data_01.inc"
//>> ---- systems ----
#include "bykranin_src/systems/roulette.pwn"
#include "bykranin_src/systems/electric_job.pwn"
new gPlayerBlockedPickup[MAX_PLAYERS] = { -1, ... };
#include "bykranin_src/systems/auction.pwn"
#include "bykranin_src/systems/m1stoks/main.inc"
#include "bykranin_src/systems/wounded.pwn"

CMD:larek(playerid, params[])
{
	#pragma unused params
	return Larek_OpenFromNotify(playerid);
}

//>> ---- systems (coords hud) ----
#include "bykranin_src/systems/coords_hud.pwn"
//>> ---- systems (blogger) ----
#include "bykranin_src/systems/blogger_system.pwn"
//>> ---- systems (object placer) ----
#include "bykranin_src/systems/object_placer.pwn"

//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/on_game_mode_init.inc"
#include "bykranin_src/core/callbacks/callbacks_01.inc"
#include "bykranin_src/core/callbacks/on_player_enter_vehicle_ex.inc"
#include "bykranin_src/core/callbacks/callbacks_02.inc"
#include "bykranin_src/core/callbacks/on_player_enter_checkpoint.inc"
#include "bykranin_src/core/callbacks/callbacks_03.inc"
//>> ---- core/combat ----
#include "bykranin_src/core/combat/combat_01.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_01.inc"
#include "bykranin_src/core/vehicle/tuning_01.inc"
#include "bykranin_src/core/vehicle/autosalon_01.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_01.inc"
//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/on_player_pick_up_pickup_ex.inc"
#include "bykranin_src/core/callbacks/callbacks_04.inc"
//>> ---- core/data ----
#include "bykranin_src/core/data/g_sellcar_price_map.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_02.inc"
//>> ---- core/data ----
#include "bykranin_src/core/data/g_flats_for_sale.inc"
#include "bykranin_src/core/data/data_02.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_03.inc"
//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/on_player_key_state_change.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_04.inc"
//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/on_player_update.inc"
#include "bykranin_src/core/callbacks/callbacks_05.inc"
#include "bykranin_src/core/callbacks/on_dialog_response.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_02.inc"
//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/on_player_click_text_draw.inc"
#include "bykranin_src/core/callbacks/callbacks_06.inc"
#include "bykranin_src/core/callbacks/on_player_enter_dynamic_area.inc"
#include "bykranin_src/core/callbacks/on_player_leave_dynamic_area.inc"
//>> ---- core/family ----
#include "bykranin_src/core/family/family_01.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_05.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_01.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_01.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_02.inc"
//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/callbacks_07.inc"
#include "bykranin_src/core/callbacks/on_player_timer.inc"
//>> ---- core/account ----
#include "bykranin_src/core/account/account_01.inc"
#include "bykranin_src/core/account/load_player_data.inc"
//>> ---- core/jobs ----
#include "bykranin_src/core/jobs/jobs_02.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_03.inc"
//>> ---- core/world ----
#include "bykranin_src/core/world/world_01.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_06.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_04.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_03.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_05.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_07.inc"
#include "bykranin_src/core/vehicle/fuel_01.inc"
//>> ---- systems ----
#include "bykranin_src/systems/fuel.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_06.inc"
//>> ---- core/social ----
#include "bykranin_src/core/social/social_01.inc"
//>> ---- core/jobs ----
#include "bykranin_src/core/jobs/jobs_03.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_08.inc"
//>> ---- core/social ----
#include "bykranin_src/core/social/social_02.inc"
//>> ---- core/admin ----
#include "bykranin_src/core/admin/admin_02.inc"
//>> ---- systems (admin nick color) ----
#include "bykranin_src/systems/admin_nick_color.pwn"
//>> ---- core/ui ----
#include "bykranin_src/core/ui/create_text_draws.inc"
//>> ---- core/casino ----
#include "bykranin_src/core/casino/casino_01.inc"
//>> ---- core/economy ----
#include "bykranin_src/core/economy/economy_01.inc"
//>> ---- core/jobs ----
#include "bykranin_src/core/jobs/jobs_04.inc"
//>> ---- core/family ----
#include "bykranin_src/core/family/family_02.inc"
//>> ---- core/account ----
#include "bykranin_src/core/account/account_02.inc"
//>> ---- core/economy ----
#include "bykranin_src/core/economy/economy_02.inc"
#include "bykranin_src/core/economy/cmd_yes.inc"
//>> ---- core/account ----
#include "bykranin_src/core/account/account_03.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_09.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_02.inc"
//>> ---- core/family ----
#include "bykranin_src/core/family/family_03.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_03.inc"
//>> ---- core/admin ----
#include "bykranin_src/core/admin/admin_03.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_04.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_07.inc"
//>> ---- core/account ----
#include "bykranin_src/core/account/account_04.inc"
//>> ---- core/social ----
#include "bykranin_src/core/social/social_03.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_08.inc"
//>> ---- core/economy ----
#include "bykranin_src/core/economy/economy_03.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_10.inc"
//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/callbacks_08.inc"
//>> ---- core/family ----
#include "bykranin_src/core/family/family_04.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_09.inc"
//>> ---- core/admin ----
#include "bykranin_src/core/admin/admin_04.inc"
//>> ---- core/family ----
#include "bykranin_src/core/family/family_05.inc"
//>> ---- core/economy ----
#include "bykranin_src/core/economy/economy_04.inc"
//>> ---- core/casino ----
#include "bykranin_src/core/casino/casino_02.inc"
//>> ---- core/world ----
#include "bykranin_src/core/world/world_02.inc"
//>> ---- core/family ----
#include "bykranin_src/core/family/family_06.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/create_all_rent_zones.inc"
#include "bykranin_src/core/property/property_10.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_05.inc"
//>> ---- core/jobs ----
#include "bykranin_src/core/jobs/jobs_05.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_04.inc"
//>> ---- core/family ----
#include "bykranin_src/core/family/family_07.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_11.inc"
//>> ---- core/social ----
#include "bykranin_src/core/social/social_04.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_11.inc"
//>> ---- core/ui ----
#include "bykranin_src/core/ui/ui_01.inc"
//>> ---- core/admin ----
#include "bykranin_src/core/admin/admin_05.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_06.inc"
//>> ---- core/ui ----
#include "bykranin_src/core/ui/ui_02.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_05.inc"
//>> ---- core/admin ----
#include "bykranin_src/core/admin/admin_06.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_07.inc"
//>> ---- core/admin ----
#include "bykranin_src/core/admin/admin_07.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_06.inc"
//>> ---- core/economy ----
#include "bykranin_src/core/economy/economy_05.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/plates_01.inc"
#include "bykranin_src/core/vehicle/ownable_12.inc"
#include "bykranin_src/core/vehicle/g_vehicle_model_name_map.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_08.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_13.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/block.inc"
#include "bykranin_src/core/inventory/inventory_07.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/tuning_02.inc"
//>> ---- core/network ----
#include "bykranin_src/core/network/ipacket_252.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_08.inc"
#include "bykranin_src/core/inventory/inventory_09.inc"
//>> ---- core/data ----
#include "bykranin_src/core/data/case_awards_num.inc"
#include "bykranin_src/core/data/case_award_names.inc"
#include "bykranin_src/core/data/data_03.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_10.inc"
//>> ---- systems ----
#include "bykranin_src/systems/blackpass.pwn"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_11.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/tuning_03.inc"
#include "bykranin_src/core/vehicle/ownable_14.inc"
#include "bykranin_src/core/vehicle/tuning_04.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_12.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_12.inc"
#include "bykranin_src/core/property/create_sale_flat_pickups.inc"
#include "bykranin_src/core/property/property_13.inc"
//>> ---- core/callbacks ----
#include "bykranin_src/core/callbacks/callbacks_09.inc"
//>> ---- core/server ----
#include "bykranin_src/core/server/server_09.inc"
//>> ---- core/inventory ----
#include "bykranin_src/core/inventory/inventory_13.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/tuning_05.inc"
#include "bykranin_src/core/vehicle/plates_02.inc"
#include "bykranin_src/core/vehicle/ownable_15.inc"
//>> ---- core/property ----
#include "bykranin_src/core/property/property_14.inc"
//>> ---- core/jobs ----
#include "bykranin_src/core/jobs/jobs_06.inc"
//>> ---- core/vehicle ----
#include "bykranin_src/core/vehicle/ownable_16.inc"
#include "bykranin_src/core/vehicle/faction_gates.inc"
