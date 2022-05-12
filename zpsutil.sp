/**
 * vim: set ts=4 :
 * =============================================================================
 * ZPSUTIL 
 * Copyright (C) 2022 https://github.com/xerox8521/ (xerox8521).  All rights reserved.
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
#pragma newdecls required
#pragma semicolon 1
#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <dhooks>

#include "preprocessor.sp"
#include "handles.sp"
#include "variables.sp"

#include "detours/Hook_OnCheckAFK.sp"
#include "detours/Hook_OnEscapeByTrigger.sp"
#include "detours/Hook_OnExecuteAction.sp"
#include "detours/Hook_OnGetSpeed.sp"
#include "detours/Hook_OnGiveAmmoToPlayer.sp"
#include "detours/Hook_OnGiveHealthPrimary.sp"
#include "detours/Hook_OnGiveHealthSecondary.sp"
#include "detours/Hook_OnGiveWeaponToPlayer.sp"
#include "detours/Hook_OnIncrementArmorValue.sp"
#include "detours/Hook_OnPlayerJoinTeam.sp"
#include "detours/Hook_OnPlayerVoiceText.sp"
#include "detours/Hook_OnPlayerWeaponPickup.sp"
#include "detours/Hook_OnRoundEnd.sp"
#include "detours/Hook_OnRoundStart.sp"
#include "detours/Hook_OnZPDataInit.sp"
#include "detours/Hook_OnEquipPlayer.sp"

#include "functions/AddBarricadeHealth.sp"
#include "functions/CreateGlobalForwards.sp"
#include "functions/CreateNatives.sp"
#include "functions/GetBarricadeHealth.sp"
#include "functions/IsMeleeWeapon.sp"
#include "functions/SetupDetours.sp"
#include "functions/SetupEntityOutputs.sp"
#include "functions/StripColors.sp"
#include "functions/GrabItemsGame_Float.sp"
#include "functions/SetMapType.sp"


#include "hooks/OnCaptureEnd.sp"
#include "hooks/OnCaptureStart.sp"
#include "hooks/OnClientPutInServer.sp"
#include "hooks/OnClientSayCommand.sp"
#include "hooks/OnEntityCreated.sp"

#include "natives/entities/Native_GetEntityMaxHealth.sp"
#include "natives/entities/Native_SetEntityMaxHealth.sp"

#include "natives/gamerules/Native_AddRoundTime.sp"
#include "natives/gamerules/Native_AddZombieLives.sp"
#include "natives/gamerules/Native_CleanupMap.sp"
#include "natives/gamerules/Native_FreeForAll.sp"
#include "natives/gamerules/Native_GetBestRoaringCarrier.sp"
#include "natives/gamerules/Native_GetCarrierArmsPushForce.sp"
#include "natives/gamerules/Native_GetHandsPushForce.sp"
#include "natives/gamerules/Native_GetRandomCarrier.sp"
#include "natives/gamerules/Native_GetRandomPlayer.sp"
#include "natives/gamerules/Native_GetRandomTeamPlayer.sp"
#include "natives/gamerules/Native_GetRoundRemainingTime.sp"
#include "natives/gamerules/Native_GetWinCount.sp"
#include "natives/gamerules/Native_GetZombieArmsPushForce.sp"
#include "natives/gamerules/Native_GetZombieLives.sp"
#include "natives/gamerules/Native_IsCustom.sp"
#include "natives/gamerules/Native_IsFreeForAll.sp"
#include "natives/gamerules/Native_IsHardcore.sp"
#include "natives/gamerules/Native_IsInTestMode.sp"
#include "natives/gamerules/Native_IsRoundOngoing.sp"
#include "natives/gamerules/Native_IsWarmup.sp"
#include "natives/gamerules/Native_SendPhoneMessage.sp"
#include "natives/gamerules/Native_SendPhoneMessageLocation.sp"
#include "natives/gamerules/Native_SendPhoneMessageToPlayer.sp"
#include "natives/gamerules/Native_SetCarrierArmsPushForce.sp"
#include "natives/gamerules/Native_SetHandsPushForce.sp"
#include "natives/gamerules/Native_SetIntermission.sp"
#include "natives/gamerules/Native_SetRoundTime.sp"
#include "natives/gamerules/Native_SetZombieArmsPushForce.sp"
#include "natives/gamerules/Native_SetZombieLives.sp"

#include "natives/player/Native_AddPlayerWeight.sp"
#include "natives/player/Native_CreateCosmeticWear.sp"
#include "natives/player/Native_DropAllWeapons.sp"
#include "natives/player/Native_GetActiveWeapon.sp"
#include "natives/player/Native_GetFlashBattery.sp"
#include "natives/player/Native_GetPlayerWeight.sp"
#include "natives/player/Native_GetRemainingInventorySlots.sp"
#include "natives/player/Native_GiveBarricadeAmmo.sp"
#include "natives/player/Native_GivePlayerWeapon.sp"
#include "natives/player/Native_HasActiveIED.sp"
#include "natives/player/Native_HasAmmoType.sp"
#include "natives/player/Native_HasDeliveryItem.sp"
#include "natives/player/Native_HasNamedPlayerItem.sp"
#include "natives/player/Native_IsAFK.sp"
#include "natives/player/Native_IsBerzerking.sp"
#include "natives/player/Native_IsCarrier.sp"
#include "natives/player/Native_IsGagged.sp"
#include "natives/player/Native_IsInfected.sp"
#include "natives/player/Native_IsInPanic.sp"
#include "natives/player/Native_IsInPhoneTrigger.sp"
#include "natives/player/Native_IsMuted.sp"
#include "natives/player/Native_IsRoaring.sp"
#include "natives/player/Native_IsWeaponSwitchAllowed.sp"
#include "natives/player/Native_OpenSteamOverlay.sp"
#include "natives/player/Native_PlayerDropWeapon.sp"
#include "natives/player/Native_RemoveCosmeticWear.sp"
#include "natives/player/Native_RemovePlayerWeight.sp"
#include "natives/player/Native_RespawnPlayer.sp"
#include "natives/player/Native_SetArmModel.sp"
#include "natives/player/Native_SetArmorValue.sp"
#include "natives/player/Native_SetEscaped.sp"
#include "natives/player/Native_SetFlashBattery.sp"
#include "natives/player/Native_SetInfection.sp"
#include "natives/player/Native_SetInfectionResistance.sp"
#include "natives/player/Native_ToggleWeaponSwitch.sp"
#include "natives/player/Native_SetMaxSpeed.sp"

#include "natives/util/Native_IsChristmas.sp"
#include "natives/util/Native_IsHalloween.sp"
#include "natives/util/Native_PlayMusic.sp"
#include "natives/util/Native_StripColors.sp"
#include "natives/util/Native_IsAprilFools.sp"
#include "natives/util/Native_IsFrenchNationalDay.sp"
#include "natives/util/Native_GetAmmoWeight.sp"
#include "natives/util/Native_SetUberPushEnabled.sp"
#include "natives/util/Native_GetMapType.sp"

#include "natives/weapons/Native_CreateFragGrenade.sp"
#include "natives/weapons/Native_DetonateGrenade.sp"
#include "natives/weapons/Native_GetClip1.sp"
#include "natives/weapons/Native_GetMaxClip1.sp"
#include "natives/weapons/Native_GetMeleeRange.sp"
#include "natives/weapons/Native_GetPrimaryAmmoType.sp"
#include "natives/weapons/Native_GetWeaponDamage.sp"
#include "natives/weapons/Native_GetWeaponOwner.sp"
#include "natives/weapons/Native_GetWeaponWeight.sp"
#include "natives/weapons/Native_IsDualSlot.sp"
#include "natives/weapons/Native_IsMeleeWeapon.sp"


public Plugin myinfo = 
{
    name = "[ZPS] Utils Linux Only",
    author = "XeroX",
    description = "Provides various utilities for Zombie Panic! Sourcemod Plugin Developers",
    version = PLUGIN_VERSION,
    url = "https://github.com/xerox8521/ZPSUTIL"
};

public void OnPluginStart()
{
    char szGameName[PLATFORM_MAX_PATH];
    GetGameFolderName(szGameName, sizeof(szGameName));
    if(!StrEqual(szGameName, "zps"))
    {
        SetFailState("This plugin is only for Zombie Panic! Source");
        return;
    }

    g_pGameConfig = new GameData("zpsutils");
    if(g_pGameConfig == null)
    {
        SetFailState("Gamedata file zpsutils.txt is missing");
        return;
    }

    IsLinux = (g_pGameConfig.GetOffset("OS") == 1);

    if(!IsLinux)
    {
        SetFailState("This Utility Plugin is only supported on Linux!");
        return;
    }

    SetupDetours();

    SetupEntityOutputs();

    sm_zps_util_colored_tags = CreateConVar("sm_zps_util_colored_tags", "0", "Enable or Disable colored messages from players in chat.\n1 = Colors allowed. 0 = No colors allowed", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    sm_zps_afk_admin_immunity = CreateConVar("sm_zps_afk_admin_immunity", "1", "Should SOURCEMOD Based admins be except from the Game AFK check.\n1 = Sourcemod Admins should be excempt. 0 = Sourcemod admins should still be checked", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    
    AutoExecConfig(true);
}

// Added as of 2021
public void OnMapInit(const char[] szMapName)
{
    SetMapType(szMapName);

    PrintToServer("MapType: %s(%d)", szMapType[MapType], MapType);
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateGlobalForwards();

    CreateNatives();

    RegPluginLibrary("zpsutil");
    return APLRes_Success;
}
