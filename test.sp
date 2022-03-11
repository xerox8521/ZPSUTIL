#include <sourcemod>
#include <sdktools>

enum
{
    AMMO_TYPE_PISTOL = 1,
    AMMO_TYPE_REVOLVER,
    AMMO_TYPE_SHOTGUN,
    AMMO_TYPE_RIFLE,
    AMMO_TYPE_BARRICADE
}

public void OnPluginStart()
{
    RegAdminCmd("sm_test", Command_Test, ADMFLAG_ROOT);
}

void ForceSuicide(int client, bool bExplode = false)
{
    static Handle hSDKCall = null;
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetVirtual(453);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    hSDKCall = EndPrepSDKCall();

    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, bExplode, false);
    }
}

public Action Command_Test(int client, int args)
{
    ForceSuicide(client);
    return Plugin_Handled;
}
