public int Native_IsFreeForAll(Handle plugin, int params)
{
    return GameRules_GetProp("m_bIsFreeForAll");
}
