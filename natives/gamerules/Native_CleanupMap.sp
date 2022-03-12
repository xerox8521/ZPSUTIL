public any Native_CleanupMap(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::CleanupMap");
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "Failed to setup SDKCall for CZombiePanic::CleanupMap. Update your gamedata!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall);
    }
    return 1;
}
