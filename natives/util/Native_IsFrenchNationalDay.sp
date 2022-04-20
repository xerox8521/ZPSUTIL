public any Native_IsFrenchNationalDay(Handle plugin, int params)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Static);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "ZPSUTILS_IsFrenchNationalDay");
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "Failed to setup SDKCall for ZPSUTILS_IsFrenchNationalDay. Update your gamedata!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall);
    }
    return 0;
}
