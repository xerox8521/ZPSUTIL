public int Native_SetCarrierArmsPushForce(Handle plugin, int params)
{
    float flForce = GetNativeCell(1);
    GameRules_SetPropFloat("m_flCustomCarrierArmsPushForce", flForce);
    return 1;
}
