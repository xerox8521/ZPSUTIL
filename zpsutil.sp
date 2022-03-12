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

#include "functions/CreateGlobalForwards.sp"
#include "functions/CreateNatives.sp"
#include "functions/IsMeleeWeapon.sp"
#include "functions/SetupDetours.sp"
#include "functions/StripColors.sp"

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

#include "natives/util/Native_IsChristmas.sp"
#include "natives/util/Native_IsHalloween.sp"
#include "natives/util/Native_PlayMusic.sp"
#include "natives/util/Native_StripColors.sp"

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

    HookEntityOutput("trigger_capturepoint_zp", "m_OnZombieCaptureStart", OnCaptureStart);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnHumanCaptureStart", OnCaptureStart);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnZombieCaptureCompleted", OnCaptureEnd);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnHumanCaptureCompleted", OnCaptureEnd);



    sm_zps_util_colored_tags = CreateConVar("sm_zps_util_colored_tags", "0", "Enable or Disable colored messages from players in chat.\n1 = Colors allowed. 0 = No colors allowed", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    sm_zps_afk_admin_immunity = CreateConVar("sm_zps_afk_admin_immunity", "1", "Should SOURCEMOD Based admins be except from the Game AFK check.\n1 = Sourcemod Admins should be except. 0 = Sourcemod admins should still be checked", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    
    AutoExecConfig(true);

    for(int i = 1; i <= MaxClients; i++)
    {
        if(!IsClientInGame(i)) continue;
        OnClientPutInServer(i);
    }
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateGlobalForwards();

    CreateNatives();

    RegPluginLibrary("zpsutil");
    return APLRes_Success;
}


public void OnClientPutInServer(int client)
{
    bModifiedChat[client] = false;
}

public void OnCaptureEnd(const char[] output, int caller, int activator, float delay)
{
    if(gfCaptured.FunctionCount > 0)
    {
        int teamindex = TEAM_LOBBY;
        if(StrEqual(output, "m_OnZombieCaptureCompleted"))
        {
            teamindex = TEAM_ZOMBIE;
        }
        else if(StrEqual(output, "m_OnHumanCaptureCompleted"))
        {
            teamindex = TEAM_SURVIVOR;
        }

        Call_StartForward(gfCaptured);
        Call_PushCell(caller);
        Call_PushCell(teamindex);
        Call_Finish();
    }  
}

public void OnCaptureStart(const char[] output, int caller, int activator, float delay)
{
    if(gfCaptureStart.FunctionCount > 0)
    {
        int teamindex = TEAM_LOBBY;
        if(StrEqual(output, "m_OnZombieCaptureStart"))
        {
            teamindex = TEAM_ZOMBIE;
        }
        else if(StrEqual(output, "m_OnHumanCaptureStart"))
        {
            teamindex = TEAM_SURVIVOR;
        }

        Call_StartForward(gfCaptureStart);
        Call_PushCell(caller);
        Call_PushCell(teamindex);
        Call_Finish();
    }   
}

public void OnEntityCreated(int entity, const char[] szClassName)
{
    if(StrEqual(szClassName, "weapon_inoculator") || StrEqual(szClassName, "weapon_inoculator_delay") || StrEqual(szClassName, "weapon_inoculator_full"))
    {
        dhHealthPrimary.HookEntity(Hook_Post, entity, Hook_OnGiveHealthPrimary);
        dhHealthSecondary.HookEntity(Hook_Post, entity, Hook_OnGiveHealthSecondary);
        dhHealthExecuteAction.HookEntity(Hook_Post, entity, Hook_OnExecuteAction);
    }
}


public Action OnClientSayCommand(int client, const char[] szCommand, const char[] szArgs)
{
    if(sm_zps_util_colored_tags.BoolValue == false)
    {
        if(IsChatTrigger())
            return Plugin_Continue;

        if(bModifiedChat[client] == false)
        {
            char buffer[PLATFORM_MAX_PATH];
            StripColors(szArgs, buffer, sizeof(buffer));
            bModifiedChat[client] = true;
            ClientCommand(client, "%s %s", szCommand, buffer);
            CreateTimer(1.5, t_ResetModifiedChat, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
            return Plugin_Stop;

        }
    }
    return Plugin_Continue;    
}

public Action t_ResetModifiedChat(Handle timer, any serial)
{
    int client = GetClientFromSerial(serial);
    if(!client) 
        return Plugin_Continue;
    if(!IsClientInGame(client)) 
        return Plugin_Continue;

    if(bModifiedChat[client])
    {
        bModifiedChat[client] = false;
    } 
    return Plugin_Continue;
}


public MRESReturn Hook_OnCheckEmitReasonablePhysicsSpew(DHookReturn hReturn)
{
    hReturn.Value = false;
    return MRES_Supercede;
}

public MRESReturn Hook_OnRoundEnd(DHookParam hParam)
{
    if(gfRoundEnd.FunctionCount > 0)
    {
        int winner = hParam.Get(1);
        if(winner != WINNER_SURVIVORS && winner != WINNER_ZOMBIES)
        {
            winner = WINNER_STALEMATE;
        }
        Call_StartForward(gfRoundEnd);
        Call_PushCell(winner);
        Call_Finish();
    }
    
    return MRES_Ignored;
}
public MRESReturn Hook_OnIncrementArmorValue(int pThis, DHookParam hParam)
{
    if(gfIncrementArmorValue.FunctionCount > 0)
    {
        int nMaxValue = hParam.Get(2);
        Call_StartForward(gfIncrementArmorValue);
        Call_PushCell(pThis);
        Call_PushCell(hParam.Get(1));
        Call_PushCellRef(nMaxValue);
        Action result = Plugin_Continue;
        Call_Finish(result);
        if(result == Plugin_Changed)
        {
            hParam.Set(2, nMaxValue);
            return MRES_ChangedHandled;
        }
    }
    return MRES_Ignored;
}
public MRESReturn Hook_OnEscapeByTrigger(int pThis, DHookParam hParam)
{
    if(gfEscapeByTrigger.FunctionCount > 0)
    {
        if(hParam.IsNull(1))
        return MRES_Ignored;
    
        int client = hParam.Get(1);
        bool bSendMessage = hParam.Get(2);

        Call_StartForward(gfEscapeByTrigger);
        Call_PushCell(pThis);
        Call_PushCell(client);
        Call_PushCell(bSendMessage);
        Call_Finish();
    }
    return MRES_Ignored;
}
public MRESReturn Hook_OnGiveHealthPrimary(int pThis, DHookReturn hReturn)
{
    if(gfHealthPrimary.FunctionCount > 0)
    {
        int owner = GetEntPropEnt(pThis, Prop_Send, "m_hOwner");
        int health = hReturn.Value;
        
        Action result = Plugin_Continue;
        Call_StartForward(gfHealthPrimary);
        Call_PushCell(pThis);
        Call_PushCell(owner);
        Call_PushCellRef(health);
        Call_Finish(result);

        if(result == Plugin_Changed)
        {
            hReturn.Value = health;
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}

public MRESReturn Hook_OnGiveHealthSecondary(int pThis, DHookReturn hReturn)
{
    if(gfHealthSecondary.FunctionCount > 0)
    {
        int owner = GetEntPropEnt(pThis, Prop_Send, "m_hOwner");
        int health = hReturn.Value;

        Action result = Plugin_Continue;
        Call_StartForward(gfHealthSecondary);
        Call_PushCell(pThis);
        Call_PushCell(owner);
        Call_PushCellRef(health);
        Call_Finish(result);

        if(result == Plugin_Changed)
        {
            hReturn.Value = health;
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}

public MRESReturn Hook_OnExecuteAction(int pThis, DHookParam hParams)
{
    if(gfHealthExecuteAction.FunctionCount > 0)
    {
        if(hParams.IsNull(1))
        return MRES_Ignored;

        int owner = GetEntPropEnt(pThis, Prop_Send, "m_hOwner");
        int target = hParams.Get(1);
        bool bPrimary = hParams.Get(2);


        Action result = Plugin_Continue;
        Call_StartForward(gfHealthExecuteAction);
        Call_PushCell(pThis);
        Call_PushCell(owner);
        Call_PushCell(target);
        Call_PushCell(bPrimary);
        Call_Finish(result);

        if(result == Plugin_Handled)
        {
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}
public MRESReturn Hook_OnRoundStart()
{
    if(gfRoundStart.FunctionCount > 0)
    {
        Call_StartForward(gfRoundStart);
        Call_Finish();
    }
    
    return MRES_Ignored;
}
public MRESReturn Hook_OnPlayerWeaponPickup(int pThis, DHookParam hParams)
{
    if(gfPlayerWeaponPickup.FunctionCount > 0)
    {
        if(!hParams.IsNull(1))
        {
            int weapon = hParams.Get(1);
            bool bUnknown = hParams.Get(2);
            int inventorySlot = hParams.Get(3);
            bool bForcePickup = hParams.Get(4);

            char szClassName[32];
            GetEntityClassname(weapon, szClassName, sizeof(szClassName));

            Action result = Plugin_Continue;

            Call_StartForward(gfPlayerWeaponPickup);
            Call_PushCell(pThis);
            Call_PushCell(weapon);
            Call_PushString(szClassName);
            Call_PushCell(bUnknown);
            Call_PushCell(inventorySlot);
            Call_PushCell(bForcePickup);
            Call_Finish(result);

            if(result == Plugin_Handled)
            {
                return MRES_Supercede;
            }
        }
    }
    
    return MRES_Ignored;
}
public MRESReturn Hook_OnGiveWeaponToPlayer(int pThis, DHookParam hParams)
{
    if(gfGiveWeaponToPlayer.FunctionCount > 0)
    {
        if(!hParams.IsNull(1) && !hParams.IsNull(2))
        {
            int receiver = hParams.Get(1);
            int weapon = hParams.Get(2);

            Action result = Plugin_Continue;

            char szClassName[32];
            GetEntityClassname(weapon, szClassName, sizeof(szClassName));

            Call_StartForward(gfGiveWeaponToPlayer);
            Call_PushCell(pThis);
            Call_PushCell(receiver);
            Call_PushCell(weapon);
            Call_PushString(szClassName);
            Call_Finish(result);

            if(result == Plugin_Handled)
            {
                return MRES_Supercede;
            }
        }
    }
    
    return MRES_Ignored;
}
public MRESReturn Hook_OnGiveAmmoToPlayer(int pThis, DHookParam hParams)
{
    if(gfGiveAmmoToPlayer.FunctionCount > 0)
    {
        if(!hParams.IsNull(1))
        {
            int receiver = hParams.Get(1);
            Action result = Plugin_Continue;

            Call_StartForward(gfGiveAmmoToPlayer);
            Call_PushCell(pThis);
            Call_PushCell(receiver);
            Call_Finish(result);
            if(result == Plugin_Handled)
            {
                return MRES_Supercede;
            }
        }
    }
    return MRES_Ignored;
}
public MRESReturn Hook_OnGetSpeed(int pThis, DHookReturn hReturn)
{
    if(gfGetSpeed.FunctionCount > 0)
    {
        if(!pThis)
        return MRES_Ignored;
        if(!IsClientInGame(pThis))
            return MRES_Ignored;

        float flSpeed = hReturn.Value;
        
        Action result = Plugin_Continue;

        Call_StartForward(gfGetSpeed);
        Call_PushCell(pThis);
        Call_PushFloatRef(flSpeed);
        Call_Finish(result);
        if(result == Plugin_Changed)
        {
            hReturn.Value = flSpeed;
            return MRES_Supercede;
        }
    }
    
    return MRES_Ignored;
}
public MRESReturn Hook_OnCheckAFK(int pThis)
{
    if(!pThis)
        return MRES_Ignored;
    if(!IsClientInGame(pThis))
        return MRES_Ignored;
    
    if(sm_zps_afk_admin_immunity.BoolValue && CheckCommandAccess(pThis, "sm_zps_afk_adm_immunity", ADMFLAG_KICK, true))
    {
        return MRES_Supercede;
    }
    return MRES_Ignored;
}
public MRESReturn Hook_OnPlayerVoiceText(int pThis, DHookParam hParams)
{
    if(gfVoiceMenu.FunctionCount > 0)
    {
        char szInternalBuffer[64];
        hParams.GetString(1, szInternalBuffer, sizeof(szInternalBuffer));

        Call_StartForward(gfVoiceMenu);
        Call_PushCell(pThis);
        Call_PushString(szInternalBuffer);
        Action result = Plugin_Continue;
        Call_Finish(result);
        if(result == Plugin_Handled)
        {
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}
public MRESReturn Hook_OnPlayerJoinTeam(int pThis, DHookReturn hReturn, DHookParam hParams)
{
    if(gfHandleJoinTeam.FunctionCount > 0)
    {
        int team = hParams.Get(1);
        if(team > 0)
        {
            Call_StartForward(gfHandleJoinTeam);
            Call_PushCell(pThis);
            Call_PushCellRef(team);

            Action result = Plugin_Continue;
            Call_Finish(result);
            if(result == Plugin_Handled)
            {
                hReturn.Value = false;
                return MRES_Supercede;
            }
            else if(result == Plugin_Changed)
            {
                hParams.Set(1, team);
                return MRES_ChangedHandled;
            }
        }
    }
    return MRES_Ignored;
}
