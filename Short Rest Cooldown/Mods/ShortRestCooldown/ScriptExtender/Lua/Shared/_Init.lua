setmetatable(Mods.ShortRestCooldown, { __index = Mods.VolitionCabinet })

local deps = {
    VCModuleUUID = "f97b43be-7398-4ea5-8fe2-be7eb3d4b5ca",
    MCMModuleUUID = "755a8a72-407f-4f0d-9a33-274ac0f0b53d"
}

local function getModName(uuid)
    if not uuid then return "Unknown Mod" end

    local mod = Ext.Mod.GetMod(uuid)
    return mod and mod.Info and mod.Info.Name or "Unknown Mod"
end

local function checkDependency(depUUID)
    local depName = getModName(depUUID)
    local currentModName = getModName(ModuleUUID)

    if not Ext.Mod.IsModLoaded(depUUID) then
        local errorMessage = string.format(
            "%s requires %s, which is missing. PLEASE MAKE SURE IT IS ENABLED IN YOUR MOD MANAGER.",
            currentModName, depName)
        Ext.Utils.PrintError(errorMessage)
        if Ext.IsServer() then
            Ext.Timer.WaitFor(2000, function()
                Osi.ShowMessageBox(Osi.GetHostCharacter(), errorMessage)
            end)
        end
        return false
    end

    return true
end

local allDependenciesLoaded = true
allDependenciesLoaded = checkDependency(deps.VCModuleUUID) and checkDependency(deps.MCMModuleUUID)

if not allDependenciesLoaded then
    SRCWarn(0, "Not all dependencies are loaded. Some functionality may be limited.")
end

function MCMGet(settingID)
    return Mods.BG3MCM.MCMAPI:GetSettingValue(settingID, ModuleUUID)
end

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

ShortRestInstance = ShortRest:New()

SubscribedEvents.SubscribeToEvents()

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion
if MODVERSION == nil then
    SRCWarn(0, "Volitio's Short Rest Cooldown loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    SRCPrint(0, "Volitio's Short Rest Cooldown version " .. versionNumber .. " loaded")
end
