public int Native_IsHardcore(Handle plugin, int params)
{
    return GameRules_GetProp("m_bInHardcore");
}
