public int Native_GetZombieLives(Handle plugin, int params)
{
    return GameRules_GetProp("m_iZombieLives");
}
