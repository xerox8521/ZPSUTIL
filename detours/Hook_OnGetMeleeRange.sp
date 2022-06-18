public MRESReturn Hook_OnGetMeleeRange(int pThis, DHookReturn hReturn)
{
    int owner = GetEntPropEnt(pThis, Prop_Send, "m_hOwner");
    if(!IsValidEntity(owner))
        return MRES_Ignored;

    float flRange = hReturn.Value;
    Action action = Plugin_Continue;

    Call_StartForward(gfOnGetMeleeRange);
    Call_PushCell(pThis);
    Call_PushCell(owner);
    Call_PushFloatRef(flRange);
    Call_Finish(action);

    if(action == Plugin_Changed)
    {
        hReturn.Value = flRange;
        return MRES_Supercede;
    }

    return MRES_Ignored;
}