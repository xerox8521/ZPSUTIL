void CreateNatives()
{
    CreateNative("IsCarrier",                   Native_IsCarrier);
    CreateNative("IsInfected",                  Native_IsInfected);
    CreateNative("IsInPhoneTrigger",            Native_IsInPhoneTrigger);
    CreateNative("IsRoaring",                   Native_IsRoaring);
    CreateNative("IsBerzerking",                Native_IsBerzerking);
    CreateNative("ToggleWeaponSwitch",          Native_ToggleWeaponSwitch);
    CreateNative("IsWeaponSwitchAllowed",       Native_IsWeaponSwitchAllowed);
    CreateNative("SetInfection",                Native_SetInfection);
    CreateNative("SetInfectionResistance",      Native_SetInfectionResistance);
    CreateNative("GetPlayerWeight",             Native_GetPlayerWeight);
    CreateNative("AddPlayerWeight",             Native_AddPlayerWeight);
    CreateNative("RemovePlayerWeight",          Native_RemovePlayerWeight);
    CreateNative("PlayerDropWeapon",            Native_PlayerDropWeapon);
    CreateNative("IsCustom",                    Native_IsCustom);
    CreateNative("CreateCosmeticWear",          Native_CreateCosmeticWear);
    CreateNative("RemoveCosmeticWear",          Native_RemoveCosmeticWear);
    CreateNative("RespawnPlayer",               Native_RespawnPlayer);
    CreateNative("GivePlayerWeapon",            Native_GivePlayerWeapon);
    CreateNative("OpenSteamOverlay",            Native_OpenSteamOverlay);
    CreateNative("GetRemainingInvSlots",        Native_GetRemainingInventorySlots);
    CreateNative("PlayerHasAmmoType",           Native_HasAmmoType);
    CreateNative("PlayerHasActiveIED",          Native_HasActiveIED);
    CreateNative("PlayerHasDeliveryItem",       Native_HasDeliveryItem);
    CreateNative("SetArmModel",                 Native_SetArmModel);
    CreateNative("SetPlayerEscaped",            Native_SetEscaped);
    CreateNative("SetPlayerArmor",              Native_SetArmorValue);
    CreateNative("SetPlayerArmour",             Native_SetArmorValue);
    CreateNative("GetActiveWeapon",             Native_GetActiveWeapon);
    CreateNative("SetEntityMaxHealth",          Native_SetEntityMaxHealth);
    CreateNative("GetEntityMaxHealth",          Native_GetEntityMaxHealth);
    CreateNative("SendPhoneMessageLocation",    Native_SendPhoneMessageLocation);
    CreateNative("SendPhoneMessage",            Native_SendPhoneMessage);
    CreateNative("SendPhoneMessageToPlayer",    Native_SendPhoneMessageToPlayer);
    CreateNative("SetRoundTime",                Native_SetRoundTime);
    CreateNative("AddRoundTime",                Native_AddRoundTime);
    CreateNative("GetRoundRemainingTime",       Native_GetRoundRemainingTime);
    CreateNative("GetRandomTeamPlayer",         Native_GetRandomTeamPlayer);
    CreateNative("GetRandomCarrier",            Native_GetRandomCarrier);
    CreateNative("GetWinCount",                 Native_GetWinCount);
    CreateNative("GetWeaponOwner",              Native_GetWeaponOwner);
    CreateNative("IsMeleeWeapon",               Native_IsMeleeWeapon);
    CreateNative("GetWeaponDamage",             Native_GetWeaponDamage);
    CreateNative("GetWeaponWeight",             Native_GetWeaponWeight);
    CreateNative("GetPrimaryAmmoType",          Native_GetPrimaryAmmoType);
    CreateNative("GetWeaponClip1",              Native_GetClip1);
    CreateNative("IsDualSlotWeapon",            Native_IsDualSlot);
    CreateNative("GetWeaponMaxClip1",           Native_GetMaxClip1);
    CreateNative("GetMeleeWeaponRange",         Native_GetMeleeRange);
    CreateNative("PlayMusic",                   Native_PlayMusic);
    CreateNative("GetZombieLives",              Native_GetZombieLives);
    CreateNative("AddZombieLives",              Native_AddZombieLives);
    CreateNative("SetZombieLives",              Native_SetZombieLives);
    CreateNative("IsHardcore",                  Native_IsHardcore);
    CreateNative("GetHandsPushForce",           Native_GetHandsPushForce);
    CreateNative("SetHandsPushForce",           Native_SetHandsPushForce);
    CreateNative("SetZombieArmsPushForce",      Native_SetZombieArmsPushForce);
    CreateNative("GetZombieArmsPushForce",      Native_GetZombieArmsPushForce);
    CreateNative("GetCarrierArmsPushForce",     Native_GetCarrierArmsPushForce);
    CreateNative("SetCarrierArmsPushForce",     Native_SetCarrierArmsPushForce);
    CreateNative("IsFreeForAll",                Native_IsFreeForAll);
    CreateNative("SetFreeForAll",               Native_FreeForAll);
    CreateNative("CreateFragGrenade",           Native_CreateFragGrenade);
    CreateNative("DetonateGrenade",             Native_DetonateGrenade);
    CreateNative("CleanupMap",                  Native_CleanupMap);
    CreateNative("GetRandomPlayer",             Native_GetRandomPlayer);
    CreateNative("GetBestRoaringCarrier",       Native_GetBestRoaringCarrier);
    CreateNative("IsInTestMode",                Native_IsInTestMode);
    CreateNative("IsRoundOngoing",              Native_IsRoundOngoing);
    CreateNative("IsWarmup",                    Native_IsWarmup);
    CreateNative("SetIntermission",             Native_SetIntermission);
    CreateNative("IsInPanic",                   Native_IsInPanic);
    CreateNative("IsAwayFromKeyBoard",          Native_IsAFK);
    CreateNative("HasNamedPlayerItem",          Native_HasNamedPlayerItem);
    CreateNative("IsHalloween",                 Native_IsHalloween);
    CreateNative("IsChristmas",                 Native_IsChristmas);
    CreateNative("StripColors",                 Native_StripColors);
    CreateNative("GivePlayerBarricade",         Native_GiveBarricadeAmmo);
    CreateNative("IsFrenchNationalDay",         Native_IsFrenchNationalDay);
    CreateNative("IsAprilFools",                Native_IsAprilFools);
}