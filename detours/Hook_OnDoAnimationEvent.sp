public MRESReturn Hook_OnDoAnimationEvent(int pThis, DHookParam hParam)
{
    int animationEvent = hParam.Get(1);

    if(animationEvent == ANIMATION_EVENT_JUMP)
    {
        Call_StartForward(gfOnPlayerJump);
        Call_PushCell(pThis);
        Call_Finish();
    }
    return MRES_Ignored;
}