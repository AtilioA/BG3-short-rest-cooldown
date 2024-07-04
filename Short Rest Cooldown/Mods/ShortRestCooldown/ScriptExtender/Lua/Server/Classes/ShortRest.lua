---@class ShortRest: MetaClass
---@field public ShouldShortRestBeBlocked boolean -- Whether the short rest should be blocked or not (redundant)
---@field private LastShortRestedTime number -- The monotonic time at which the last short rest was performed
ShortRest = _Class:Create("ShortRest")

function ShortRest:Init()
    self.ShouldShortRestBeBlocked = false
    self.LastShortRestedTime = nil
    self.CooldownDuration = MCMGet("cooldown_duration")
    self.OnlyInMultiplayer = MCMGet("only_in_multiplayer")

    -- Check state of short rest upon loading a save: if it was blocked, then enable it again.
    -- This is necessary because, if the cooldown is too long and the player saves and reloads, the short rest will be blocked, but the cooldown will not be active anymore, so short resting would be disabled indefinitely.
    SRCModVars = Ext.Vars.GetModVariables(ModuleUUID)
    if SRCModVars then
        SRCModVars.HasBlockedShortRest = SRCModVars.HasBlockedShortRest or {}
        if SRCModVars.HasBlockedShortRest[1] then
            self:EnableShortRest()
        end
    end
end

function ShortRest:HandleCooldownFinished(timer)
    SRCDebug(1, "Short rest cooldown has finished.")
    self.ShouldShortRestBeBlocked = false
    self:EnableShortRest()
end

--- Checks if the short rest cooldown is active.
function ShortRest:IsCooldownActive()
    -- Nil check for LastShortRestedTime: if it's nil, then the cooldown is not active.
    if not self.LastShortRestedTime then
        return false
    end

    -- Fetch the current time and the cooldown duration from the config to compare.
    local currentTime = Ext.Utils.MonotonicTime()

    -- Cooldown is active if the time difference between the current time and the last short rested time is less than the cooldown duration.
    return (currentTime - self.LastShortRestedTime) <
        (self.CooldownDuration * 1000) -- MonotonicTime returns time in milliseconds
end

function ShortRest:DisableShortRest()
    Osi.SetShortRestAvailable(0)
    SRCPrint(0, "Short rest is now disabled.")
    SRCModVars = Ext.Vars.GetModVariables(ModuleUUID)
    SRCModVars.HasBlockedShortRest = { true }
end

function ShortRest:EnableShortRest()
    Osi.SetShortRestAvailable(1)
    SRCPrint(0, "Short rest is now enabled.")
    SRCModVars = Ext.Vars.GetModVariables(ModuleUUID)
    SRCModVars.HasBlockedShortRest = { false }
end

--- Handles the short rested event, applying the cooldown if necessary.
---@param character GUIDSTRING
function ShortRest:HandleShortRested(character)
    if not character then
        SRCWarn(0, "Character is nil, can't handle short rest event.")
        return
    end

    local charEntity = Ext.Entity.Get(character)
    if not charEntity then
        SRCWarn(0, "Character entity is nil, can't handle short rest event.")
        return
    end

    SRCDebug(1, "Short rest event triggered for character " .. character)
    SRCDebug(2, tostring(Osi.GetUserCount()) .. " players are currently connected.")
    if self.OnlyInMultiplayer and Osi.GetUserCount() <= 1 then
        SRCDebug(1, "Short rest cooldown is only applied in multiplayer, skipping.")
        return
    end

    Ext.Timer.WaitFor(self.CooldownDuration * 1000, function()
        self:HandleCooldownFinished()
    end)

    if self:IsCooldownActive() then
        SRCPrint(0, "Short rest is currently blocked due to a cooldown of " .. self.CooldownDuration .. " seconds.")
    else
        SRCDebug(1, "Short rest is not on cooldown. Proceeding with short rest.")
        self.LastShortRestedTime = Ext.Utils.MonotonicTime()
        self:DisableShortRest()
    end
end

return ShortRest
