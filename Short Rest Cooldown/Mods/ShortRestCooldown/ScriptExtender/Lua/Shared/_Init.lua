setmetatable(Mods.ShortRestCooldown, { __index = Mods.VolitionCabinet })

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
    "Classes/_Init",
    "SubscribedEvents",
    "EventHandlers",
})

local VCModuleUUID = "f97b43be-7398-4ea5-8fe2-be7eb3d4b5ca"
if (not Ext.Mod.IsModLoaded(VCModuleUUID)) then
  Ext.Utils.Print("VOLITION CABINET HAS NOT BEEN LOADED. PLEASE MAKE SURE IT IS ENABLED IN YOUR MOD MANAGER.")
end

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion
if MODVERSION == nil then
    SRCWarn(0, "Volitio's Short Rest Cooldown loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    SRCPrint(0, "Volitio's Short Rest Cooldown version " .. versionNumber .. " loaded")
end

ShortRestInstance = ShortRest:New()

SubscribedEvents.SubscribeToEvents()
