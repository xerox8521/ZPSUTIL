public any Native_IncrementFragCount(Handle plugin, int argc)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CBasePlayer::IncrementFragCount");
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CBasePlayer::IncrementFragCount. Update your game data!");
            return 0;
        }
    }

    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, GetNativeCell(2));
    }
    return 1;
}