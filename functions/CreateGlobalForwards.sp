void CreateGlobalForwards()
{
    gfHandleJoinTeam = CreateGlobalForward("OnPlayerJoinTeam", ET_Event, Param_Cell, Param_CellByRef);
    gfVoiceMenu = CreateGlobalForward("OnPlayerVoiceText", ET_Event, Param_Cell, Param_String);
    gfGiveAmmoToPlayer = CreateGlobalForward("OnPlayerGiveAmmoToPlayer", ET_Event, Param_Cell, Param_Cell);
    gfGiveWeaponToPlayer = CreateGlobalForward("OnPlayerGiveWeaponToPlayer", ET_Event, Param_Cell, Param_Cell, Param_Cell, Param_String);
    gfPlayerWeaponPickup = CreateGlobalForward("OnPlayerPickupWeapon", ET_Event, Param_Cell, Param_Cell, Param_String, Param_Cell, Param_Cell, Param_Cell);

    gfHealthPrimary = CreateGlobalForward("OnInoculatorGiveHealthPrimary", ET_Event, Param_Cell, Param_Cell, Param_CellByRef);
    gfHealthSecondary = CreateGlobalForward("OnInoculatorGiveHealthSecondary", ET_Event, Param_Cell, Param_Cell, Param_CellByRef);
    gfHealthExecuteAction = CreateGlobalForward("OnInoculatorExecuteAction", ET_Event, Param_Cell, Param_Cell, Param_Cell);

    gfCaptureStart = CreateGlobalForward("OnStartCapture", ET_Ignore, Param_Cell, Param_Cell);
    gfCaptured = CreateGlobalForward("OnCaptured", ET_Ignore, Param_Cell, Param_Cell);

    gfEscapeByTrigger = CreateGlobalForward("OnEscapeByTrigger", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);

    gfRoundStart = CreateGlobalForward("OnRoundStart", ET_Ignore);
    gfRoundEnd = CreateGlobalForward("OnRoundEnd", ET_Ignore, Param_Cell);

    gfIncrementArmorValue = CreateGlobalForward("OnIncrementArmorValue", ET_Event, Param_Cell, Param_Cell, Param_CellByRef);

    gfEquipPlayer = CreateGlobalForward("OnEquipPlayer", ET_Ignore, Param_Cell);
}
