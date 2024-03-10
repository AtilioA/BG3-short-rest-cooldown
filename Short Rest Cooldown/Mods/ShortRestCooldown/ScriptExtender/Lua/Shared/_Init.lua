setmetatable(Mods.ShortRestCooldown, {__index = Mods.VolitionCabinet})

---Ext.Require files at the path
---@param path string
---@param files string[]
function RequireFiles(path, files)
    for _, file in pairs(files) do
        Ext.Require(string.format("%s%s.lua", path, file))
    end
end

RequireFiles("Shared/", {
    "MetaClass",
    "Helpers/_Init",
})

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion

if MODVERSION == nil then
    SRCWarn(0, "loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    SRCPrint(0, "version " .. versionNumber .. " loaded")
end

-- local EventSubscription = Ext.Require("Shared/SubscribedEvents.lua")
-- EventSubscription.SubscribeToEvents()
