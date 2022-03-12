public int Native_SetHandsPushForce(Handle plugin, int params)
{
    float flForce = GetNativeCell(1);
    GameRules_SetPropFloat("m_flCustomHandsPushForce", flForce);
    return 1;
}
