public any Native_SetIntermission(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::SetIntermission");
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "Failed to setup SDKCall for CZombiePanic::SetIntermission. Update your gamedata!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, GetNativeCell(1));
    }
    return 1;
}
