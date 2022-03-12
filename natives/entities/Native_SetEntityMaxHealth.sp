
public int Native_SetEntityMaxHealth(Handle plugin, int params)
{
    int entity = GetNativeCell(1);
    if(!IsValidEntity(entity)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity inded %d is invalid", entity);

    SetEntProp(entity, Prop_Data, "m_iMaxHealth", GetNativeCell(2));
    return 1;
}
