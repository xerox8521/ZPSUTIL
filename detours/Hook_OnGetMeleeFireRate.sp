public MRESReturn Hook_OnGetMeleeFireRate(int pThis, DHookReturn hReturn)
{
    int owner = GetEntPropEnt(pThis, Prop_Send, "m_hOwner");
    if(!IsValidEntity(owner))
        return MRES_Ignored;
    if(GetEntProp(pThis, Prop_Send, "m_bBerzerking"))
    {
        hReturn.Value = 0.54;
    }
    else
    {
        hReturn.Value = 0.6;
    }
    return MRES_Supercede;
}