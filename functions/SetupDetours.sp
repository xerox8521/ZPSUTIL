void SetupDetours()
{
    dhHealthPrimary = DynamicHook.FromConf(g_pGameConfig, "OnGiveHealthPrimary");
    if(dhHealthPrimary == null)
    {
        SetFailState("Failed to setup OnGiveHealthPrimary hook. Update your Gamedata!");
        return;
    }
    dhHealthSecondary = DynamicHook.FromConf(g_pGameConfig, "OnGiveHealthSecondary");
    if(dhHealthSecondary == null)
    {
        SetFailState("Failed to setup OnGiveHealthSecondary hook. Update your Gamedata!");
        return;
    }
    
    dhHealthExecuteAction = DynamicHook.FromConf(g_pGameConfig, "OnExecuteAction");
    if(dhHealthExecuteAction == null)
    {
        SetFailState("Failed to setup OnExecuteAction hook. Update your Gamedata!");
        return;
    }

    dhGetMeleeFireRate = DynamicHook.FromConf(g_pGameConfig, "OnGetMeleeFireRate");
    if(dhGetMeleeFireRate == null)
    {
        SetFailState("Failed to setup OnGetMeleeFireRate. Update your Gamedata!");
        return;
    }

    dhGetMeleeRange = DynamicHook.FromConf(g_pGameConfig, "OnGetMeleeRange");
    if(dhGetMeleeRange == null)
    {
        SetFailState("Failed to setup OnGetMeleeRange. Update your Gamedata!");
        return;
    }
    
    ddHandleJoinTeam = DynamicDetour.FromConf(g_pGameConfig, "OnPlayerJoinTeam");
    if(ddHandleJoinTeam == null)
    {
        SetFailState("Failed to setup OnPlayerJoinTeam detour. Update your Gamedata!");
        return;
    }

    ddHandleJoinTeam.Enable(Hook_Post, Hook_OnPlayerJoinTeam);
    
    ddVoiceMenu = DynamicDetour.FromConf(g_pGameConfig, "OnPlayerVoiceMenu");
    if(ddVoiceMenu == null)
    {
        SetFailState("Failed to setup OnPlayerVoiceMenu hook. Update your Gamedata!");
        return;
    }

    ddVoiceMenu.Enable(Hook_Post, Hook_OnPlayerVoiceText);
    
    ddOnGiveAmmoToPlayer = DynamicDetour.FromConf(g_pGameConfig, "OnGiveAmmoToPlayer");
    if(ddOnGiveAmmoToPlayer == null)
    {
        SetFailState("Failed to setup OnGiveAmmoToPlayer hook. Update your Gamedata!");
        return;
    }

    ddOnCheckAFK = DynamicDetour.FromConf(g_pGameConfig, "OnCheckAFK");
    if(ddOnCheckAFK == null)
    {
        SetFailState("Failed to setup OnCheckAFK detour. Update your Gamedata!");
        return;
    }
    ddOnCheckAFK.Enable(Hook_Pre, Hook_OnCheckAFK);

    ddOnGetSpeed = DynamicDetour.FromConf(g_pGameConfig, "OnGetSpeed");
    if(ddOnGetSpeed == null)
    {
        SetFailState("Failed to setup OnGetSpeed detour. Update your Gamedata!");
        return;
    }
    ddOnGetSpeed.Enable(Hook_Post, Hook_OnGetSpeed);

    ddOnGiveAmmoToPlayer = DynamicDetour.FromConf(g_pGameConfig, "OnGiveAmmoToPlayer");
    if(ddOnGiveAmmoToPlayer == null)
    {
        SetFailState("Failed to setup OnGiveAmmoToPlayer detour. Update your Gamedata!");
        return;
    }
    ddOnGiveAmmoToPlayer.Enable(Hook_Post, Hook_OnGiveAmmoToPlayer);
    
    ddOnGiveWeaponToPlayer = DynamicDetour.FromConf(g_pGameConfig, "OnGiveWeaponToPlayer");
    if(ddOnGiveWeaponToPlayer == null)
    {
        SetFailState("Failed to setup OnGiveWeaponToPlayer detour. Update your Gamedata!");
        return;
    }
    ddOnGiveWeaponToPlayer.Enable(Hook_Post, Hook_OnGiveWeaponToPlayer);


    ddOnPlayerWeaponPickup = DynamicDetour.FromConf(g_pGameConfig, "OnPlayerWeaponPickup");
    if(ddOnPlayerWeaponPickup == null)
    {
        SetFailState("Failed to setup OnPlayerWeaponPickup detour. Update your Gamedata!");
        return;
    }
    ddOnPlayerWeaponPickup.Enable(Hook_Post, Hook_OnPlayerWeaponPickup);
    
    ddOnRoundStart = DynamicDetour.FromConf(g_pGameConfig, "OnRoundStart");
    if(ddOnRoundStart == null)
    {
        SetFailState("Failed to setup OnRoundStart detour. Update your Gamedata!");
        return;
    }
    ddOnRoundStart.Enable(Hook_Post, Hook_OnRoundStart);
    
    ddOnEscapeByTrigger = DynamicDetour.FromConf(g_pGameConfig, "OnEscapeByTrigger");
    if(ddOnEscapeByTrigger == null)
    {
        SetFailState("Failed to setup OnEscapeByTrigger detour. Update your Gamedata!");
        return;
    }
    ddOnEscapeByTrigger.Enable(Hook_Post, Hook_OnEscapeByTrigger);

    ddOnIncrementArmorValue = DynamicDetour.FromConf(g_pGameConfig, "OnIncrementArmorValue");
    if(ddOnIncrementArmorValue == null)
    {
        SetFailState("Failed to setup OnIncrementArmorValue detour. Update your Gamedata!");
        return;
    }
    ddOnIncrementArmorValue.Enable(Hook_Pre, Hook_OnIncrementArmorValue);
    
    ddOnRoundEnd = DynamicDetour.FromConf(g_pGameConfig, "OnRoundEnd");
    if(ddOnRoundEnd == null)
    {
        SetFailState("Failed to setup OnRoundEnd detour. Update your Gamedata!");
        return;
    }
    ddOnRoundEnd.Enable(Hook_Post, Hook_OnRoundEnd);

    ddOnZPDataInitialize = DynamicDetour.FromConf(g_pGameConfig, "CZPDataInitialize");
    if(ddOnZPDataInitialize == null)
    {
        SetFailState("Failed to setup CZPData::Initialize detour. Update your Gamedata!");
        return;
    }
    ddOnZPDataInitialize.Enable(Hook_Post, Hook_OnZPDataInit);

    ddOnEquipPlayer = DynamicDetour.FromConf(g_pGameConfig, "OnEquipPlayer");
    if(ddOnEquipPlayer == null)
    {
        SetFailState("Failed to setup OnEquipPlayer detour. Update your Gamedata!");
        return;
    }
    ddOnEquipPlayer.Enable(Hook_Post, Hook_OnEquipPlayer);

    ddOnDoAnimationEvent = DynamicDetour.FromConf(g_pGameConfig, "OnDoAnimationEvent");
    if(ddOnDoAnimationEvent == null)
    {
        SetFailState("Failed to setup OnDoAnimationEvent detour. Update your Gamedata!");
        return;
    }
    ddOnDoAnimationEvent.Enable(Hook_Post, Hook_OnDoAnimationEvent);

    ddOnGetArmorAmmo = DynamicDetour.FromConf(g_pGameConfig, "OnGetArmorAmmo");
    if(ddOnGetArmorAmmo == null)
    {
        SetFailState("Failed to setup OnGetArmorAmmo detour. Update your Gamedata!");
        return;
    }
    ddOnGetArmorAmmo.Enable(Hook_Pre, Hook_OnGetArmorAmmo);
}
