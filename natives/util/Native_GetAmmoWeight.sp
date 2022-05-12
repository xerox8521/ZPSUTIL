public int Native_GetAmmoWeight(Handle plugin, int params)
{
    int ammoType = GetNativeCell(1);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Static);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "ZPSUTILS_GetAmmoWeight");
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "SDKCall for GetAmmoWeight failed");
            return 0;
        }
        return SDKCall(hSDKCall, ammoType);
    }
    else
    {
        return SDKCall(hSDKCall, ammoType);
    }
}