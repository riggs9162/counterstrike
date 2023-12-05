local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

cs.netvar = cs.netvar or {}
cs.netvar.globals = cs.netvar.globals or {}

net.Receive("cs.NetVars.GlobalVarSet", function()
    cs.netvar.globals[net.ReadString()] = net.ReadType()
end)

net.Receive("cs.NetVars.NetVarSet", function()
    local index = net.ReadUInt(16)

    cs.netvar[index] = cs.netvar[index] or {}
    cs.netvar[index][net.ReadString()] = net.ReadType()
end)

net.Receive("cs.NetVars.NetVarDelete", function()
    cs.netvar[net.ReadUInt(16)] = nil
end)

net.Receive("cs.NetVars.LocalVarSet", function()
    local key = net.ReadString()
    local var = net.ReadType()

    cs.netvar[LocalPlayer():EntIndex()] = cs.netvar[LocalPlayer():EntIndex()] or {}
    cs.netvar[LocalPlayer():EntIndex()][key] = var

    hook.Run("OnLocalVarSet", key, var)
end)

function GetNetVar(key, default) // luacheck: globals GetNetVar
    local value = cs.netvar.globals[key]

    return value != nil and value or default
end

function entityMeta:GetNetVar(key, default)
    local index = self:EntIndex()

    if (cs.netvar[index] and cs.netvar[index][key] != nil) then
        return cs.netvar[index][key]
    end

    return default
end

playerMeta.GetLocalVar = entityMeta.GetNetVar