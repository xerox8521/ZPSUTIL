#include <sourcemod>
#include <sdktools>
#include <zpsutil>

public Action OnGetPlayerSpeed(int client, float &flSpeed)
{
    flSpeed = flSpeed * 1.2;
    return Plugin_Changed;
}
public Action OnPlayerJoinTeam(int client, int &team)
{
    PrintToChatAll("OnPlayerJoinTeam(%N, %d)", client, team);
    return Plugin_Continue;
}

public void OnPluginStart()
{
    RegAdminCmd("sm_test", Command_Test, ADMFLAG_ROOT);
    RegAdminCmd("sm_test2", Command_Test2, ADMFLAG_ROOT);
}

public Action Command_Test2(int client, int args)
{
    char m_AdminStrFlags[PLATFORM_MAX_PATH];
    GetEntPropString(client, Prop_Send, "m_AdminStrFlags", m_AdminStrFlags, sizeof(m_AdminStrFlags));
    PrintToChat(client, "m_AdminStrFlags: %s", m_AdminStrFlags);
    return Plugin_Handled;
}
public Action Command_Test(int client, int args)
{
    // 
    PrintToChat(client, "Attachment: %d", LookupAttachment(client, "anim_attachment_RH"));
    return Plugin_Handled;
}