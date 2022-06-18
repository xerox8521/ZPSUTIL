public MRESReturn Hook_OnEquipPlayer(int pThis)
{
    Call_StartForward(gfEquipPlayer);
    Call_PushCell(pThis);
    Call_Finish();
    return MRES_Ignored;
}