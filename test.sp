#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zpsutil>
#include <dhooks>

ConVar sv_zps_hardcore = null;

GameData g_pGameConfig = null;

DynamicHook dhOnBarricadeCollide;

public void OnPluginStart()
{
    //RegAdminCmd("sm_test", Command_Test, ADMFLAG_ROOT);
    //RegAdminCmd("sm_roar", Command_Roar, ADMFLAG_ROOT);
    //RegAdminCmd("sm_maxspeed", Command_Speed, ADMFLAG_ROOT);

    LoadTranslations("common.phrases");

    g_pGameConfig = new GameData("test");
    if(g_pGameConfig == null)
    {
        SetFailState("Missing gamedata test.txt");
        return;
    }

    //sv_zps_hardcore = FindConVar("sv_zps_hardcore");

    RegAdminCmd("sm_grenades", Command_Grenades, ADMFLAG_ROOT);

    dhOnBarricadeCollide = DynamicHook.FromConf(g_pGameConfig, "OnShouldCollide");
}

enum
{
	COLLISION_GROUP_NONE  = 0,
	COLLISION_GROUP_DEBRIS,			// Collides with nothing but world and static stuff
	COLLISION_GROUP_DEBRIS_TRIGGER, // Same as debris, but hits triggers
	COLLISION_GROUP_INTERACTIVE_DEBRIS,	// Collides with everything except other interactive debris or debris
	COLLISION_GROUP_INTERACTIVE,	// Collides with everything except interactive debris or debris
	COLLISION_GROUP_PLAYER,
	COLLISION_GROUP_BREAKABLE_GLASS,
	COLLISION_GROUP_VEHICLE,
	COLLISION_GROUP_PLAYER_MOVEMENT,  // For HL2, same as Collision_Group_Player, for
										// TF2, this filters out other players and CBaseObjects
	COLLISION_GROUP_NPC,			// Generic NPC group
	COLLISION_GROUP_IN_VEHICLE,		// for any entity inside a vehicle
	COLLISION_GROUP_WEAPON,			// for any weapons that need collision detection
	COLLISION_GROUP_VEHICLE_CLIP,	// vehicle clip brush to restrict vehicle movement
	COLLISION_GROUP_PROJECTILE,		// Projectiles!
	COLLISION_GROUP_DOOR_BLOCKER,	// Blocks entities not permitted to get near moving doors
	COLLISION_GROUP_PASSABLE_DOOR,	// Doors that the player shouldn't collide with
	COLLISION_GROUP_DISSOLVING,		// Things that are dissolving are in this group
	COLLISION_GROUP_PUSHAWAY,		// Nonsolid on client and server, pushaway in player code

	COLLISION_GROUP_NPC_ACTOR,		// Used so NPCs in scripts ignore the player.
	COLLISION_GROUP_NPC_SCRIPTED,	// USed for NPCs in scripts that should not collide with each other

	LAST_SHARED_COLLISION_GROUP
}

public Action Command_Grenades(int client, int args)
{
    int ent = INVALID_ENT_REFERENCE;
    while ((ent = FindEntityByClassname(ent, "weapon_frag")) != -1)
		if (IsValidEntity(ent))
            RemoveEntity(ent);
    return Plugin_Handled;
}

public Action OnGetArmorAmmo(int client, int &MaxArmor)
{
    MaxArmor = 200;
    return Plugin_Changed;
}

public MRESReturn OnShouldCollide(int pThis, DHookReturn hReturn, DHookParam hParams)
{
    int collisionGroup = hParams.Get(1);
    int team = hParams.Get(3);
    if(collisionGroup == COLLISION_GROUP_PLAYER_MOVEMENT)
    {
        if(team == TEAM_SURVIVOR)
        {
            hReturn.Value = false;
            return MRES_Supercede;  
        }
    }
    return MRES_Ignored;
}


public void OnEntityCreated(int entity, const char[] szClassName)
{
    if(StrEqual(szClassName, "prop_barricade"))
    {
        //dhOnBarricadeCollide.HookEntity(Hook_Post, entity, OnShouldCollide);
    }
}


int GetBarricadeHealth(int client, int index)
{
    static Handle hSDKCall = null;
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::GetBarricadeHealth");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    hSDKCall = EndPrepSDKCall();
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, client, index);
    }
    return 0;
}

void AddBarricadeHealth(int client, int index, int health)
{
    static Handle hSDKCall = null;
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::AddBarricadeHealth");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    hSDKCall = EndPrepSDKCall();
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, index, health);
    }
}

void GiveBarricade(int client, int amount)
{
    int k, l;

    GivePlayerAmmo(client, amount, AMMO_TYPE_BARRICADE);
    
    for(k = 0; k != amount; ++k)
    {
        for(l = 1; l != 7; ++l)
        {
            if(!GetBarricadeHealth(client, l))
                break;
        }
        AddBarricadeHealth(client, l, (sv_zps_hardcore.BoolValue == false) ? 450 : 350);
    }
}

public Action Command_Test(int client, int args)
{
    Handle warmup = StartMessageOne("Warmup", client, USERMSG_BLOCKHOOKS | USERMSG_RELIABLE);
    BfWrite bf = UserMessageToBfWrite(warmup);
    bf.WriteFloat(GetGameTime() + 999999.0);
    EndMessage();
    return Plugin_Handled;
}

void SetRoarState(int client, bool bToggle)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::SetRoarState");
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
    }
    
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, bToggle);
    }
}

public Action Command_Speed(int client, int args)
{
    char arg1[32];
    GetCmdArg(1, arg1, sizeof(arg1));

    SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", StringToFloat(arg1));
    PrintToChat(client, "MaxSpeed set to %0.2f", GetEntPropFloat(client, Prop_Send, "m_flMaxspeed"));
    return Plugin_Handled;
}
public Action Command_Roar(int client, int args)
{
    char arg1[32];
    GetCmdArg(1, arg1, sizeof(arg1));
    int target = FindTarget(client, arg1, false, false);
    if(target == -1)
    {
        return Plugin_Handled;
    }
    if(IsRoaring(target))
    {
        SetRoarState(target, false);
    }
    else
    {
        SetRoarState(target, true);
    }
    PrintToChat(client, "Toggled roar state for %N", target);
    return Plugin_Handled;
}
