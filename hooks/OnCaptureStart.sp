public void OnCaptureStart(const char[] output, int caller, int activator, float delay)
{
    if(gfCaptureStart.FunctionCount > 0)
    {
        int teamindex = TEAM_LOBBY;
        if(StrEqual(output, "m_OnZombieCaptureStart"))
        {
            teamindex = TEAM_ZOMBIE;
        }
        else if(StrEqual(output, "m_OnHumanCaptureStart"))
        {
            teamindex = TEAM_SURVIVOR;
        }

        Call_StartForward(gfCaptureStart);
        Call_PushCell(caller);
        Call_PushCell(teamindex);
        Call_Finish();
    }   
}
