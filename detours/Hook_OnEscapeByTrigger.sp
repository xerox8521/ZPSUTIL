public MRESReturn Hook_OnEscapeByTrigger(int pThis, DHookParam hParam)
{
    if(gfEscapeByTrigger.FunctionCount > 0)
    {
        if(hParam.IsNull(1))
        return MRES_Ignored;
    
        int client = hParam.Get(1);
        bool bSendMessage = hParam.Get(2);

        Call_StartForward(gfEscapeByTrigger);
        Call_PushCell(pThis);
        Call_PushCell(client);
        Call_PushCell(bSendMessage);
        Call_Finish();
    }
    return MRES_Ignored;
}
