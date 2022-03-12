public int Native_SetZombieArmsPushForce(Handle plugin, int params)
{
    float flForce = GetNativeCell(1);
    GameRules_SetPropFloat("m_flCustomZombieArmsPushForce", flForce);
    return 1;
}
