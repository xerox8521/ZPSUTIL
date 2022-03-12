public any Native_IsRoundOngoing(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::IsRoundOngoing");
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "Failed to setup SDKCall for CZombiePanic::IsRoundOngoing. Update your gamedata!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return 0;
}
