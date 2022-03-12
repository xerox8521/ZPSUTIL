public int Native_FreeForAll(Handle plugin, int params)
{
    bool bEnable = GetNativeCell(1);
    GameRules_SetProp("m_bIsFreeForAll", bEnable);
    return 1;
}
