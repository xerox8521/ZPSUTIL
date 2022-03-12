public MRESReturn Hook_OnExecuteAction(int pThis, DHookParam hParams)
{
    if(gfHealthExecuteAction.FunctionCount > 0)
    {
        if(hParams.IsNull(1))
        return MRES_Ignored;

        int owner = GetEntPropEnt(pThis, Prop_Send, "m_hOwner");
        int target = hParams.Get(1);
        bool bPrimary = hParams.Get(2);


        Action result = Plugin_Continue;
        Call_StartForward(gfHealthExecuteAction);
        Call_PushCell(pThis);
        Call_PushCell(owner);
        Call_PushCell(target);
        Call_PushCell(bPrimary);
        Call_Finish(result);

        if(result == Plugin_Handled)
        {
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}
