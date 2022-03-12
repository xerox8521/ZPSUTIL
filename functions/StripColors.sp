void StripColors(const char[] szMessage, char[] szBuffer, int maxlength)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Static);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "ZPSUTILS_StripColors");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_SetReturnInfo(SDKType_String, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("SDK Setup failed for ZPSUTILS_StripColors. Update your Gamedata!");
            return;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, szBuffer, maxlength, szMessage);
    }
}