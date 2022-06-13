/*
    You might be asking why this is an SDKCall when we literally used a netprop in Native_IsInfected.
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
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::SetInfection");
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
