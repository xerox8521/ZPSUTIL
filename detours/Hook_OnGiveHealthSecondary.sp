public MRESReturn Hook_OnGiveHealthSecondary(int pThis, DHookReturn hReturn)
{
    if(gfHealthSecondary.FunctionCount > 0)
    {
        int owner = GetEntPropEnt(pThis, Prop_Send, "m_hOwner");
        int health = hReturn.Value;

        Action result = Plugin_Continue;
        Call_StartForward(gfHealthSecondary);
        Call_PushCell(pThis);
        Call_PushCell(owner);
        Call_PushCellRef(health);
        Call_Finish(result);

        if(result == Plugin_Changed)
        {
            hReturn.Value = health;
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}
