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
