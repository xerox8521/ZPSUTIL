public MRESReturn Hook_OnPlayerVoiceText(int pThis, DHookParam hParams)
{
    if(gfVoiceMenu.FunctionCount > 0)
    {
        char szInternalBuffer[64];
        hParams.GetString(1, szInternalBuffer, sizeof(szInternalBuffer));

        Call_StartForward(gfVoiceMenu);
        Call_PushCell(pThis);
        Call_PushString(szInternalBuffer);
        Action result = Plugin_Continue;
        Call_Finish(result);
        if(result == Plugin_Handled)
        {
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}
