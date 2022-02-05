#if defined _zpsutil_included
 #endinput
#endif
#define _zpsutil_included

enum AmmoType
{
    AMMO_TYPE_PISTOL = 1,
    AMMO_TYPE_REVOLVER,
    AMMO_TYPE_SHOTGUN,
    AMMO_TYPE_RIFLE,
    AMMO_TYPE_BARRICADE
}


// Return Plugin_Changed if you have modifed team
// Return Plugin_Handled to prevent the player from joining a team.
forward Action OnPlayerJoinTeam(int client, int &team);
// Return Plugin_Changed if you have modifed flSpeed
forward Action OnGetPlayerSpeed(int client, float &flSpeed);
// Return Plugin_Handled to prevent the receiver from getting the ammo from client.
forward Action OnPlayerGiveAmmoToPlayer(int client, int receiver);
// Return Plugin_Handled to prevent the receiver from getting the weapon from client
// szWeaponName is the classname of the weapon
forward Action OnPlayerGiveWeaponToPlayer(int client, int receiver, int weapon, const char[] szWeaponName);
// Return Plugin Handled to prevent the player from picking up the weapon.
forward Action OnPlayerPickupWeapon(int client, int weapon, const char[] szWeaponName, bool bUnknown, int inventorySlot, bForcePickupSlot);

native bool IsCarrier(int client);
native bool IsInfected(int client);
native bool IsWeaponSwitchAllowed(int client);
native bool IsInPhoneTrigger(int client);
native bool IsRoaring(int client);
native bool IsBerzerking(int client);
native bool IsCustom();
native bool PlayerHasAmmoType(int client, AmmoType ammoType);
native bool PlayerHasActiveIED(int client);
native bool PlayerHasDeliveryItem(int client);

native float GetFlashBattery(int client);
native float SetFlashBattery(int client, float battery);

native void PlayerDropWeapon(int client, int weapon, bool bUknown = false);

native int GivePlayerWeapon(int client, const char[] szWeaponName);

native int GetRemainingInvSlots(int client);

native int GetActiveWeapon(int client);

// internally calls Precache on the model
native void SetArmModel(int client, const char[] szArmModel);

// Pick your poison
native void SetPlayerArmor(int client, int armor);
native void SetPlayerArmour(int client, int armour);

native float GetPlayerWeight(int client);
native void AddPlayerWeight(int client, float weight);
native void RemovePlayerWeight(int client, float weight);

// This function internally makes all the function calls required
// to make the player properly escape. Eg. Drop Weapons, Armor, Stop any pending infection etc.
native void SetPlayerEscaped(int client, bool bToObserver = true, bool bPlaySound = true);

// Player needs to have "Allow servers to open my Steam overlay to web pages" or cl_allow_servers_to_use_steam_overlay 1
// Can be enabled in ZP!S Options -> Custom Content otherwise this does nothing.
native void OpenSteamOverlay(int client, const char[] szURL);

// cl_allow_musics_from_network 


native void ToggleWeaponSwitch(int client, bool bAllow);
// Infection time defaults to 30-45 seconds unless specified.
native void SetInfection(int client, bool bInfection, bool bForced, int infectionTime = -1);
native void SetInfectionResistance(int client, int percentage, float time);
native void CreateCosmeticWear(int client, const char[] szModelName);
native void RemoveCosmeticWear(int client, const char[] szModelName);


public SharedPlugin __pl_zpsutil = 
{
	name = "zpsutil",
	file = "zpsutil.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_zpsutil_SetNTVOptional()
{
   MarkNativeAsOptional("IsCarrier");
   MarkNativeAsOptional("IsInfected");
   MarkNativeAsOptional("IsWeaponSwitchAllowed");
   MarkNativeAsOptional("IsInPhoneTrigger");
   MarkNativeAsOptional("IsRoaring");
   MarkNativeAsOptional("IsBerzerking");
   MarkNativeAsOptional("IsCustom");
   MarkNativeAsOptional("PlayerHasAmmoType");
   MarkNativeAsOptional("GetFlashBattery");
   MarkNativeAsOptional("SetFlashBattery");
   MarkNativeAsOptional("PlayerDropWeapon");
   MarkNativeAsOptional("GivePlayerWeapon");
   MarkNativeAsOptional("GetRemainingInvSlots");
   MarkNativeAsOptional("GetPlayerWeight");
   MarkNativeAsOptional("AddPlayerWeight");
   MarkNativeAsOptional("RemovePlayerWeight");
   MarkNativeAsOptional("OpenSteamOverlay");
   MarkNativeAsOptional("ToggleWeaponSwitch");
   MarkNativeAsOptional("SetInfection");
   MarkNativeAsOptional("SetInfectionResistance");
   MarkNativeAsOptional("CreateCosmeticWear");
   MarkNativeAsOptional("RemoveCosmeticWear");
   MarkNativeAsOptional("PlayerHasActiveIED");
   MarkNativeAsOptional("PlayerHasDeliveryItem");
   MarkNativeAsOptional("SetArmModel");
   MarkNativeAsOptional("SetPlayerEscaped");
   MarkNativeAsOptional("SetPlayerArmor");
   MarkNativeAsOptional("SetPlayerArmour");
   MarkNativeAsOptional("LookupEntityAttachment");
}
#endif