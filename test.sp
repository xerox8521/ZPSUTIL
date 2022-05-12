#include <sourcemod>
#include <sdktools>
#include <zpsutil>

ConVar sv_zps_hardcore = null;

GameData g_pGameConfig = null;

public void OnPluginStart()
{
    RegAdminCmd("sm_test", Command_Test, ADMFLAG_ROOT);
    RegAdminCmd("sm_roar", Command_Roar, ADMFLAG_ROOT);
    RegAdminCmd("sm_maxspeed", Command_Speed, ADMFLAG_ROOT);

    LoadTranslations("common.phrases");

    g_pGameConfig = new GameData("test");
    if(g_pGameConfig == null)
    {
        SetFailState("Missing gamedata test.txt");
        return;
    }

    sv_zps_hardcore = FindConVar("sv_zps_hardcore");
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
    GiveBarricade(client, 5);
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
