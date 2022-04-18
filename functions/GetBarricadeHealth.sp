int GetBarricadeHealth(int client, int index)
{
    static Handle hSDKCall = null;
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::GetBarricadeHealth");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    hSDKCall = EndPrepSDKCall();
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, client, index);
    }
    return 0;
}