void AddBarricadeHealth(int client, int index, int health)
{
    static Handle hSDKCall = null;
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::AddBarricadeHealth");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    hSDKCall = EndPrepSDKCall();
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, client, index, health);
    }
}
