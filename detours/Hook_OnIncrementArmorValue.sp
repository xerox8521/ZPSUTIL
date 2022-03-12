public MRESReturn Hook_OnIncrementArmorValue(int pThis, DHookParam hParam)
{
    if(gfIncrementArmorValue.FunctionCount > 0)
    {
        int nMaxValue = hParam.Get(2);
        Call_StartForward(gfIncrementArmorValue);
        Call_PushCell(pThis);
        Call_PushCell(hParam.Get(1));
        Call_PushCellRef(nMaxValue);
        Action result = Plugin_Continue;
        Call_Finish(result);
        if(result == Plugin_Changed)
        {
            hParam.Set(2, nMaxValue);
            return MRES_ChangedHandled;
        }
    }
    return MRES_Ignored;
}
