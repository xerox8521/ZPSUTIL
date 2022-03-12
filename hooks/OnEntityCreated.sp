public void OnEntityCreated(int entity, const char[] szClassName)
{
    if(StrEqual(szClassName, "weapon_inoculator") || StrEqual(szClassName, "weapon_inoculator_delay") || StrEqual(szClassName, "weapon_inoculator_full"))
    {
        dhHealthPrimary.HookEntity(Hook_Post, entity, Hook_OnGiveHealthPrimary);
        dhHealthSecondary.HookEntity(Hook_Post, entity, Hook_OnGiveHealthSecondary);
        dhHealthExecuteAction.HookEntity(Hook_Post, entity, Hook_OnExecuteAction);
    }
}
