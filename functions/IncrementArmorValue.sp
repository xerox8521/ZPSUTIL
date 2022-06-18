void IncrementArmorValue(int client, int nCount, int nMaxCount)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CBasePlayer::IncrementArmorValue");
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, nCount, nMaxCount);
    }
}