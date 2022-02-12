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

#define PLUGIN_VERSION "1.0.0"

#define TEAM_LOBBY 0
#define TEAM_SPECTATOR 1
#define TEAM_SURVIVOR 2
#define TEAM_ZOMBIE 3

GameData g_pGameConfig = null;

DynamicHook dhHandleJoinTeam = null;
DynamicHook dhVoiceMenu = null;
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

GlobalForward gfHandleJoinTeam = null;
GlobalForward gfVoiceMenu = null;
GlobalForward gfGetSpeed = null;
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


ConVar sm_zps_util_colored_tags = null;
ConVar sm_zps_afk_admin_immunity = null;

bool bModifiedChat[MAXPLAYERS+1];

public Plugin myinfo = 
{
    name = "[ZPS] Utils",
    author = "XeroX",
    description = "Provides various utilties for Zombie Panic! Source",
    version = PLUGIN_VERSION,
    url = ""
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
    
    dhHandleJoinTeam = DynamicHook.FromConf(g_pGameConfig, "OnPlayerJoinTeam");
    if(dhHandleJoinTeam == null)
    {
        SetFailState("Failed to setup OnPlayerJoinTeam hook. Update your Gamedata!");
        return;
    }
    
    dhVoiceMenu = DynamicHook.FromConf(g_pGameConfig, "OnPlayerVoiceMenu");
    if(dhVoiceMenu == null)
    {
        SetFailState("Failed to setup OnPlayerVoiceMenu hook. Update your Gamedata!");
        return;
    }
    
    dhHealthPrimary = DynamicHook.FromConf(g_pGameConfig, "OnGiveHealthPrimary");
    if(dhHealthPrimary == null)
    {
        SetFailState("Failed to setup OnGiveHealthPrimary hook. Update your Gamedata!");
        return;
    }
    dhHealthSecondary = DynamicHook.FromConf(g_pGameConfig, "OnGiveHealthSecondary");
    if(dhHealthSecondary == null)
    {
        SetFailState("Failed to setup OnGiveHealthSecondary hook. Update your Gamedata!");
        return;
    }
    
    dhHealthExecuteAction = DynamicHook.FromConf(g_pGameConfig, "OnExecuteAction");
    if(dhHealthExecuteAction == null)
    {
        SetFailState("Failed to setup OnExecuteAction hook. Update your Gamedata!");
        return;
    }
    
    ddOnGiveAmmoToPlayer = DynamicDetour.FromConf(g_pGameConfig, "OnGiveAmmoToPlayer");
    if(ddOnGiveAmmoToPlayer == null)
    {
        SetFailState("Failed to setup OnGiveAmmoToPlayer hook. Update your Gamedata!");
        return;
    }

    ddOnCheckAFK = DynamicDetour.FromConf(g_pGameConfig, "OnCheckAFK");
    if(ddOnCheckAFK == null)
    {
        SetFailState("Failed to setup OnCheckAFK detour. Update your Gamedata!");
        return;
    }
    ddOnCheckAFK.Enable(Hook_Post, Hook_OnCheckAFK);

    ddOnGetSpeed = DynamicDetour.FromConf(g_pGameConfig, "OnGetSpeed");
    if(ddOnGetSpeed == null)
    {
        SetFailState("Failed to setup OnGetSpeed detour. Update your Gamedata!");
        return;
    }
    ddOnGetSpeed.Enable(Hook_Post, Hook_OnGetSpeed);

    ddOnGiveAmmoToPlayer = DynamicDetour.FromConf(g_pGameConfig, "OnGiveAmmoToPlayer");
    if(ddOnGiveAmmoToPlayer == null)
    {
        SetFailState("Failed to setup OnGiveAmmoToPlayer detour. Update your Gamedata!");
        return;
    }
    ddOnGiveAmmoToPlayer.Enable(Hook_Post, Hook_OnGiveAmmoToPlayer);
    
    ddOnGiveWeaponToPlayer = DynamicDetour.FromConf(g_pGameConfig, "OnGiveWeaponToPlayer");
    if(ddOnGiveWeaponToPlayer == null)
    {
        SetFailState("Failed to setup OnGiveWeaponToPlayer detour. Update your Gamedata!");
        return;
    }
    ddOnGiveWeaponToPlayer.Enable(Hook_Post, Hook_OnGiveWeaponToPlayer);


    ddOnPlayerWeaponPickup = DynamicDetour.FromConf(g_pGameConfig, "OnPlayerWeaponPickup");
    if(ddOnPlayerWeaponPickup == null)
    {
        SetFailState("Failed to setup OnPlayerWeaponPickup detour. Update your Gamedata!");
        return;
    }
    ddOnPlayerWeaponPickup.Enable(Hook_Post, Hook_OnPlayerWeaponPickup);
    
    ddOnRoundStart = DynamicDetour.FromConf(g_pGameConfig, "OnRoundStart");
    if(ddOnRoundStart == null)
    {
        SetFailState("Failed to setup OnRoundStart detour. Update your Gamedata!");
        return;
    }
    ddOnRoundStart.Enable(Hook_Post, Hook_OnRoundStart);
    
    ddOnEscapeByTrigger = DynamicDetour.FromConf(g_pGameConfig, "OnEscapeByTrigger");
    if(ddOnEscapeByTrigger == null)
    {
        SetFailState("Failed to setup OnEscapeByTrigger detour. Update your Gamedata!");
        return;
    }
    ddOnEscapeByTrigger.Enable(Hook_Post, Hook_OnEscapeByTrigger);

    HookEvent("endslate", Event_RoundEnd);



    sm_zps_util_colored_tags = CreateConVar("sm_zps_util_colored_tags", "0", "Enable or Disable colored messages from players in chat.\n1 = Colors allowed. 0 = No colors allowed", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    sm_zps_afk_admin_immunity = CreateConVar("sm_zps_afk_admin_immunity", "1", "Should SOURCEMOD Based admins be except from the Game AFK check.\n1 = Sourcemod Admins should be except. 0 = Sourcemod admins should still be checked", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    
    AutoExecConfig(true);

    for(int i = 1; i <= MaxClients; i++)
    {
        if(!IsClientInGame(i)) continue;
        OnClientPutInServer(i);
    }

    HookEntityOutput("trigger_capturepoint_zp", "m_OnZombieCaptureStart", OnCaptureStart);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnHumanCaptureStart", OnCaptureStart);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnZombieCaptureCompleted", OnCaptureEnd);
    HookEntityOutput("trigger_capturepoint_zp", "m_OnHumanCaptureCompleted", OnCaptureEnd);
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    gfHandleJoinTeam = CreateGlobalForward("OnPlayerJoinTeam", ET_Event, Param_Cell, Param_CellByRef);
    gfVoiceMenu = CreateGlobalForward("OnPlayerVoiceText", ET_Event, Param_Cell, Param_String);
    gfGetSpeed = CreateGlobalForward("OnGetPlayerSpeed", ET_Event, Param_Cell, Param_FloatByRef);
    gfGiveAmmoToPlayer = CreateGlobalForward("OnPlayerGiveAmmoToPlayer", ET_Event, Param_Cell, Param_Cell);
    gfGiveWeaponToPlayer = CreateGlobalForward("OnPlayerGiveWeaponToPlayer", ET_Event, Param_Cell, Param_Cell, Param_Cell, Param_String);
    gfPlayerWeaponPickup = CreateGlobalForward("OnPlayerPickupWeapon", ET_Event, Param_Cell, Param_Cell, Param_String, Param_Cell, Param_Cell, Param_Cell);

    gfHealthPrimary = CreateGlobalForward("OnInoculatorGiveHealthPrimary", ET_Event, Param_Cell, Param_Cell, Param_CellByRef);
    gfHealthSecondary = CreateGlobalForward("OnInoculatorGiveHealthSecondary", ET_Event, Param_Cell, Param_Cell, Param_CellByRef);
    gfHealthExecuteAction = CreateGlobalForward("OnInoculatorExecuteAction", ET_Event, Param_Cell, Param_Cell, Param_Cell);

    gfCaptureStart = CreateGlobalForward("OnStartCapture", ET_Ignore, Param_Cell, Param_Cell);
    gfCaptured = CreateGlobalForward("OnCaptured", ET_Ignore, Param_Cell, Param_Cell);

    gfEscapeByTrigger = CreateGlobalForward("OnEscapeByTrigger", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);

    gfRoundStart = CreateGlobalForward("OnRoundStart", ET_Ignore);
    gfRoundEnd = CreateGlobalForward("OnRoundEnd", ET_Ignore, Param_Cell);

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
    

    RegPluginLibrary("zpsutil");
    return APLRes_Success;
}


public void OnClientPutInServer(int client)
{
    dhHandleJoinTeam.HookEntity(Hook_Pre, client, Hook_OnPlayerJoinTeam);
    dhVoiceMenu.HookEntity(Hook_Post, client, Hook_OnPlayerVoiceText);

    bModifiedChat[client] = false;
}

public void OnCaptureEnd(const char[] output, int caller, int activator, float delay)
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

public void OnCaptureStart(const char[] output, int caller, int activator, float delay)
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

public void Event_RoundEnd(Event event, const char[] szName, bool dontBroadcast)
{
    char win_text[32];
    event.GetString("win_text", win_text, sizeof(win_text));

    int winner = 0;
    if(StrEqual(win_text, "human"))
    {
        winner = 1;
    }
    else if(StrEqual(win_text, "zombie"))
    {
        winner = 2;
    }
    else if(StrEqual(win_text, "stalemate"))
    {
        winner = 3;
    }

    Call_StartForward(gfRoundEnd);
    Call_PushCell(winner);
    Call_Finish();
}


public MRESReturn Hook_OnEscapeByTrigger(int pThis, DHookParam hParam)
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

    return MRES_Ignored;
}
public MRESReturn Hook_OnGiveHealthPrimary(int pThis, DHookReturn hReturn)
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
    return MRES_Ignored;
}

public MRESReturn Hook_OnGiveHealthSecondary(int pThis, DHookReturn hReturn)
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
    return MRES_Ignored;
}

public MRESReturn Hook_OnExecuteAction(int pThis, DHookParam hParams)
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
    return MRES_Ignored;
}
public MRESReturn Hook_OnRoundStart()
{
    Call_StartForward(gfRoundStart);
    Call_Finish();
    return MRES_Ignored;
}
public MRESReturn Hook_OnPlayerWeaponPickup(int pThis, DHookParam hParams)
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
    return MRES_Ignored;
}
public MRESReturn Hook_OnGiveWeaponToPlayer(int pThis, DHookParam hParams)
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
    return MRES_Ignored;
}
public MRESReturn Hook_OnGiveAmmoToPlayer(int pThis, DHookParam hParams)
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
    return MRES_Ignored;
}
public MRESReturn Hook_OnGetSpeed(int pThis, DHookReturn hReturn)
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
    return MRES_Ignored;
}
public MRESReturn Hook_OnCheckAFK(int pThis)
{
    if(!pThis)
        return MRES_Ignored;
    if(!IsClientInGame(pThis))
        return MRES_Ignored;
    
    if(sm_zps_afk_admin_immunity.BoolValue)
    {
        if(CheckCommandAccess(pThis, "sm_zps_afk_adm_immunity", ADMFLAG_KICK, true))
        {
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}
public MRESReturn Hook_OnPlayerVoiceText(int pThis, DHookParam hParams)
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
    return MRES_Ignored;
}
public MRESReturn Hook_OnPlayerJoinTeam(int pThis, DHookReturn hReturn, DHookParam hParams)
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
    return MRES_Ignored;
}

void StripColors(const char[] szMessage, char[] szBuffer, int maxlength)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Static);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "ZPSUTILS_StripColors");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_SetReturnInfo(SDKType_String, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("SDK Setup failed for ZPSUTILS_StripColors. Update your Gamedata!");
            return;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, szBuffer, maxlength, szMessage);
    }
}


public int Native_SetHandsPushForce(Handle plugin, int params)
{
    float flForce = GetNativeCell(1);
    GameRules_SetPropFloat("m_flCustomHandsPushForce", flForce);
    return 1;
}

public any Native_GetHandsPushForce(Handle plugin, int params)
{
    return GameRules_GetPropFloat("m_flCustomHandsPushForce");
}

public int Native_SetZombieArmsPushForce(Handle plugin, int params)
{
    float flForce = GetNativeCell(1);
    GameRules_SetPropFloat("m_flCustomZombieArmsPushForce", flForce);
    return 1;
}

public any Native_GetCarrierArmsPushForce(Handle plugin, int params)
{
    return GameRules_GetPropFloat("m_flCustomCarrierArmsPushForce");
}

public int Native_SetCarrierArmsPushForce(Handle plugin, int params)
{
    float flForce = GetNativeCell(1);
    GameRules_SetPropFloat("m_flCustomCarrierArmsPushForce", flForce);
    return 1;
}

public any Native_GetZombieArmsPushForce(Handle plugin, int params)
{
    return GameRules_GetPropFloat("m_flCustomZombieArmsPushForce");
}

public int Native_IsHardcore(Handle plugin, int params)
{
    return GameRules_GetProp("m_bInHardcore");
}

public int Native_IsFreeForAll(Handle plugin, int params)
{
    return GameRules_GetProp("m_bIsFreeForAll");
}

public int Native_FreeForAll(Handle plugin, int params)
{
    bool bEnable = GetNativeCell(1);
    GameRules_SetProp("m_bIsFreeForAll", bEnable);
    return 1;
}

public int Native_GetZombieLives(Handle plugin, int params)
{
    return GameRules_GetProp("m_iZombieLives");
}

public int Native_AddZombieLives(Handle plugin, int params)
{
    int iZombieLives = GameRules_GetProp("m_iZombieLives");
    iZombieLives += GetNativeCell(1);
    GameRules_SetProp("m_iZombieLives", iZombieLives);
    return 1;
}

public int Native_SetZombieLives(Handle plugin, int params)
{
    GameRules_SetProp("m_iZombieLives", GetNativeCell(1));
    return 1;
}
public int Native_IsCarrier(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntProp(client, Prop_Send, "m_bIsCarrier");
}
public int Native_IsInfected(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntProp(client, Prop_Send, "m_bIsInfected");
}

public int Native_IsCustom(Handle plugin, int params)
{
    return GameRules_GetProp("m_iIsCustom");
}

public int Native_IsWeaponSwitchAllowed(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntProp(client, Prop_Send, "m_bAllowWeaponSwitch");
}
public int Native_IsInPhoneTrigger(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntProp(client, Prop_Send, "m_bInPhoneTrigger");
}

public int Native_IsRoaring(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntProp(client, Prop_Send, "m_bIsRoaring");
}

public int Native_IsBerzerking(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntProp(client, Prop_Send, "m_bBerzerking");
}

public any Native_GetPlayerWeight(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntPropFloat(client, Prop_Send, "m_flPlayerWeight");
}

public any Native_GetFlashBattery(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    return GetEntPropFloat(client, Prop_Send, "m_flFlashBattery");
}
public int Native_SetFlashBattery(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    SetEntPropFloat(client, Prop_Send, "m_flFlashBattery", GetNativeCell(2));
    return 1;
}

public int Native_AddPlayerWeight(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    float weight = GetNativeCell(2);
    float curWeight = GetEntPropFloat(client, Prop_Send, "m_flPlayerWeight");
    if((curWeight + weight) > 30.0)
    {
        SetEntPropFloat(client, Prop_Send, "m_flPlayerWeight", 30.0);
    }
    else
    {
        SetEntPropFloat(client, Prop_Send, "m_flPlayerWeight", (curWeight + weight));
    }
    return 1;
}
public int Native_RemovePlayerWeight(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    float weight = GetNativeCell(2);
    float curWeight = GetEntPropFloat(client, Prop_Send, "m_flPlayerWeight");
    if((curWeight - weight) < 0.0)
    {
        SetEntPropFloat(client, Prop_Send, "m_flPlayerWeight", 0.0);
    }
    else
    {
        SetEntPropFloat(client, Prop_Send, "m_flPlayerWeight", (curWeight - weight));
    }
    return 1;
}

public int Native_ToggleWeaponSwitch(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    SetEntProp(client, Prop_Send, "m_bAllowWeaponSwitch", !GetNativeCell(2));
    return 1;
}

/*
    You might be asking why this is an SDKCall when we litterally used a netprop in Native_IsInfected.
    Well short answer is ZP!S needs more than just the boolean to be set.
    So instead of having to update 3-4 Offsets everytime they break
    We just use a function offset which handles everything else for us.
*/
public int Native_SetInfection(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    if(GetClientTeam(client) != TEAM_SURVIVOR) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not a survivor", client);
    
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CZP_Player::SetInfection");
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::SetInfection. Update your game data!");
            return 0;
        }
    }

    if(hSDKCall != null)
    {
        int infectionTime = GetNativeCell(4);
        if(infectionTime == -1)
        {
            infectionTime = GetRandomInt(30, 45);
        }
        SDKCall(hSDKCall, client, GetNativeCell(2), GetNativeCell(3), infectionTime);
    }
    return 1;
}
public int Native_SetInfectionResistance(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    if(GetClientTeam(client) != TEAM_SURVIVOR) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not a survivor", client);
    
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CZP_Player::SetInfectionResistance");
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::SetInfectionResistance. Update your game data!");
            return 0;
        }
    }

    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, GetNativeCell(2), GetNativeCell(3));
    }
    return 1;
}

public int Native_PlayerDropWeapon(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    if(GetClientTeam(client) != TEAM_SURVIVOR) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not a survivor", client);
    
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::DropWeapon");
        PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::DropWeapon. Update your game data!");
            return 0;
        }
    }

    int weapon = GetNativeCell(2);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, weapon, GetNativeCell(3));
    }
    return 1;
}

public int Native_CreateCosmeticWear(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::CreateCosmeticWear");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::CreateCosmeticWear. Update your game data!");
            return 0;
        }
    }

    if(hSDKCall != null)
    {
        int length;
        GetNativeStringLength(1, length);

        char[] szModelName = new char[length+2];

        GetNativeString(1, szModelName, length+1);

        SDKCall(hSDKCall, client, szModelName);
        return 1;
    }
    return 0;
}

public int Native_RemoveCosmeticWear(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::RemoveCosmeticWear");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::RemoveCosmeticWear. Update your game data!");
            return 0;
        }
    }

    if(hSDKCall != null)
    {
        int length;
        GetNativeStringLength(1, length);

        char[] szModelName = new char[length+2];

        GetNativeString(1, szModelName, length+1);

        SDKCall(hSDKCall, client, szModelName);
        return 1;
    }
    return 0;
}

public int Native_GivePlayerWeapon(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::GiveWeapon");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::GiveWeapon. Update your game data!");
            return INVALID_ENT_REFERENCE;
        }
    }

    if(hSDKCall != null)
    {
        int length;
        GetNativeStringLength(2, length);

        char[] szWeaponName = new char[length+2];

        GetNativeString(2, szWeaponName, length+1);
        return SDKCall(hSDKCall, client, szWeaponName, -1, false);
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_SetArmModel(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::SetArmModel");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::SetArmModel. Update your game data!");
            return 0;
        }
    }

    if(hSDKCall != null)
    {
        int length;
        GetNativeStringLength(2, length);

        char[] szModelName = new char[length+2];

        GetNativeString(2, szModelName, length+1);
        SDKCall(hSDKCall, client, szModelName);
        return 1;
    }
    return 0;
}

public int Native_OpenSteamOverlay(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    int length;
    GetNativeStringLength(2, length);

    char[] szWebsite = new char[length+2];

    GetNativeString(2, szWebsite, length+1);

    ClientCommand(client, "opensteamoverlay %s", szWebsite);
    return 1;
}

public int Native_RespawnPlayer(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::DoRespawn");
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::DoRespawn. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client);
        return 1;
    }
    return 0;
}

public int Native_GetRemainingInventorySlots(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::NumSlots");
        PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::NumSlots. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, client);
    }
    return 0;
}

public int Native_HasAmmoType(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::HasAmmoType");
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::HasAmmoType. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, client, GetNativeCell(2));
    }
    return 0;
}

public int Native_SetEscaped(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Static);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player_SetEscaped");
        PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player_SetEscaped. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, GetNativeCell(2), GetNativeCell(3));
        return 1;
    }
    return 0;
}

public int Native_HasActiveIED(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    int ied = INVALID_ENT_REFERENCE;
    while ((ied = FindEntityByClassname(ied, "npc_ied")) != INVALID_ENT_REFERENCE)
    {
        if(GetEntProp(ied, Prop_Send, "m_bIsLive"))
        {
            if(GetEntPropEnt(ied, Prop_Send, "m_hThrower") == client)
            return 1;
        }
    }
    return 0;
}

public int Native_HasDeliveryItem(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    int item_delivery = INVALID_ENT_REFERENCE;
    char szClassName[32];
    for(int i = 0; i < 6; i++)
    {
        item_delivery = GetPlayerWeaponSlot(client, i);
        if(item_delivery == -1) continue;
        GetEntityClassname(item_delivery, szClassName, sizeof(szClassName));
        
        if(StrEqual(szClassName, "item_delivery"))
        {
            return 1;
        }
    }
    return 0;
}

public int Native_SetArmorValue(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    SetEntProp(client, Prop_Send, "m_iArmor", GetNativeCell(2));
    return 1;
}

public int Native_GetActiveWeapon(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    return GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
}

public int Native_SetEntityMaxHealth(Handle plugin, int params)
{
    int entity = GetNativeCell(1);
    if(!IsValidEntity(entity)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity inded %d is invalid", entity);

    SetEntProp(entity, Prop_Data, "m_iMaxHealth", GetNativeCell(2));
    return 1;
}
public int Native_GetEntityMaxHealth(Handle plugin, int params)
{
    int entity = GetNativeCell(1);
    if(!IsValidEntity(entity)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity inded %d is invalid", entity);

    return GetEntProp(entity, Prop_Data, "m_iMaxHealth");
}

public int Native_SendPhoneMessageLocation(Handle plugin, int params)
{
    int length;

    GetNativeStringLength(1, length);
    char[] szMessage = new char[length+2];
    GetNativeString(1, szMessage, length+1);

    float vecLoc[3];
    GetNativeArray(2, vecLoc, 3);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::SendPhoneMessageLocation");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByValue);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::SendPhoneMessageLocation. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, szMessage, vecLoc, GetNativeCell(3), GetNativeCell(4));
    }
    return 1;
}


public int Native_SendPhoneMessage(Handle plugin, int params)
{
    int length;

    GetNativeStringLength(1, length);
    char[] szMessage = new char[length+2];
    GetNativeString(1, szMessage, length+1);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::SendPhoneMessage");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::SendPhoneMessage. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, szMessage, GetNativeCell(2));
    }
    return 1;
}

public int Native_SendPhoneMessageToPlayer(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    int length;
    GetNativeStringLength(2, length);
    
    char[] szMessage = new char[length+2];
    GetNativeString(2, szMessage, length+1);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::SendPhoneMessageToPlayer");
        PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::SendPhoneMessageToPlayer. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, szMessage);
    }
    return 1;
}

public int Native_SetRoundTime(Handle plugin, int params)
{
    float flRoundTime = GetNativeCell(1);

    flRoundTime = (GetGameTime() + flRoundTime);
    GameRules_SetPropFloat("m_flRoundTime", flRoundTime);
    return 1;
}

public int Native_AddRoundTime(Handle plugin, int params)
{
    float flRoundTime = GetNativeCell(1);

    float flCurrentRoundTime = GameRules_GetPropFloat("m_flRoundTime");
    flCurrentRoundTime += flRoundTime;
    GameRules_SetPropFloat("m_flRoundTime", flCurrentRoundTime);
    return 1;
}

public any Native_GetRoundRemainingTime(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::GetRemainingRoundTime");
        PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::GetRemainingRoundTime. Update your game data!");
            return -1;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall);
    }
    return -1;
}

public int Native_GetRandomTeamPlayer(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::GetRandomTeamPlayer");
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_CBasePlayer, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::GetRandomTeamPlayer. Update your game data!");
            return INVALID_ENT_REFERENCE;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1), GetNativeCell(2));
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_GetRandomCarrier(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::GetRandomCarrier");
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_CBasePlayer, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::GetRandomCarrier. Update your game data!");
            return INVALID_ENT_REFERENCE;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_GetWinCount(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::GetWins");
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::GetWins. Update your game data!");
            return -1;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return -1;
}

public int Native_GetWeaponOwner(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    return GetEntPropEnt(weapon, Prop_Send, "m_hOwner");
}


bool IsMeleeWeapon(int weapon)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CWeaponZPBase::IsMeleeWeapon");
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CWeaponZPBase::IsMeleeWeapon. Update your game data!");
            return false;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, weapon);
    }
    return false;
}

public int Native_IsMeleeWeapon(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);
    return IsMeleeWeapon(weapon);
}

public any Native_GetWeaponDamage(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CWeaponZPBase::GetWeaponDamage");
        PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CWeaponZPBase::GetWeaponDamage. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return 0;
}

public any Native_GetWeaponWeight(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CWeaponZPBase::WeaponWeight");
        PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CWeaponZPBase::WeaponWeight. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return 0;
}

public any Native_IsDualSlot(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CBaseCombatWeapon::IsDualSlot");
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CBaseCombatWeapon::IsDualSlot. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return 0;
}

public any Native_GetMaxClip1(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CBaseCombatWeapon::GetMaxClip1");
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CBaseCombatWeapon::GetMaxClip1. Update your game data!");
            return -1;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return -1;
}

public any Native_GetMeleeRange(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    if(!IsMeleeWeapon(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a melee weapon", szClassName, weapon);


    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CWeaponMeleeBase::GetRange");
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CWeaponMeleeBase::GetRange. Update your game data!");
            return -1;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return -1;
}

public any Native_GetPrimaryAmmoType(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    if(!HasEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType"))
        return -1;
    return GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");
}

public any Native_GetClip1(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    if(!HasEntProp(weapon, Prop_Send, "m_iClip1"))
        return -1;
    return GetEntProp(weapon, Prop_Send, "m_iClip1");
}


public any Native_PlayMusic(Handle plugin, int params)
{
    int length;
    GetNativeStringLength(1, length);

    char[] szTrack = new char[length+2];

    GetNativeString(1, szTrack, length+1);

    GetNativeStringLength(2, length);

    char[] szTitle = new char[length+2];

    GetNativeString(1, szTitle, length+1);

    Event event = CreateEvent("force_song", true);
    if(event != null)
    {
        event.SetString("song", szTrack);
        event.SetString("title", szTitle);
        event.Fire();
    }
    return 1;
}




