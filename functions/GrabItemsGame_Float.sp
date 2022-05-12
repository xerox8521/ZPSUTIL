float GrabItemsGame_Float(const char[] node, const char[] category, const char[] key)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Raw);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZPData::GrabItemsGame_Float");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            LogError("SDKCall setup for CZPData::GrabItemsGame_Float failed");
            return -1.0;
        }
    }
    return SDKCall(hSDKCall, gZPData, node, category, key);
}