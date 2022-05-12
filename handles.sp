GameData g_pGameConfig = null;

DynamicHook dhHealthPrimary = null;
DynamicHook dhHealthSecondary = null;
DynamicHook dhHealthExecuteAction = null;

DynamicDetour ddOnCheckAFK = null;
DynamicDetour ddOnGetSpeed = null;
DynamicDetour ddOnGiveAmmoToPlayer = null;
DynamicDetour ddOnGiveWeaponToPlayer = null;
DynamicDetour ddOnPlayerWeaponPickup = null;
DynamicDetour ddOnRoundStart = null;
DynamicDetour ddOnEscapeByTrigger = null;
DynamicDetour ddOnIncrementArmorValue = null;
DynamicDetour ddHandleJoinTeam = null;
DynamicDetour ddVoiceMenu = null;
DynamicDetour ddOnRoundEnd = null;
DynamicDetour ddOnZPDataInitialize = null;
DynamicDetour ddOnEquipPlayer = null;

GlobalForward gfHandleJoinTeam = null;
GlobalForward gfVoiceMenu = null;
GlobalForward gfGiveAmmoToPlayer = null;
GlobalForward gfGiveWeaponToPlayer = null;
GlobalForward gfPlayerWeaponPickup = null;
GlobalForward gfRoundStart = null;
GlobalForward gfRoundEnd = null;
GlobalForward gfHealthPrimary = null;
GlobalForward gfHealthSecondary = null;
GlobalForward gfHealthExecuteAction = null;
GlobalForward gfEscapeByTrigger = null;
GlobalForward gfCaptureStart = null;
GlobalForward gfCaptured = null;
GlobalForward gfIncrementArmorValue = null;
GlobalForward gfEquipPlayer = null;


ConVar sm_zps_util_colored_tags = null;
ConVar sm_zps_afk_admin_immunity = null;