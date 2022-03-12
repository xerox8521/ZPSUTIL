public int Native_AddZombieLives(Handle plugin, int params)
{
    int iZombieLives = GameRules_GetProp("m_iZombieLives");
    iZombieLives += GetNativeCell(1);
    GameRules_SetProp("m_iZombieLives", iZombieLives);
    return 1;
}
