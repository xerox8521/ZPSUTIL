public int Native_GetEntityMaxHealth(Handle plugin, int params)
{
    int entity = GetNativeCell(1);
    if(!IsValidEntity(entity)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity inded %d is invalid", entity);

    return GetEntProp(entity, Prop_Data, "m_iMaxHealth");
}
