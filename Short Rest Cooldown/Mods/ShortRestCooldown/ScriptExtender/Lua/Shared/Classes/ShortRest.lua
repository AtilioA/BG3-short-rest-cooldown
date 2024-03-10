---@class ShortRest: MetaClass
---@field public ShouldShortRestBeBlocked boolean -- Whether the short rest should be blocked or not (redundant)
---@field private LastShortRestedTime number -- The monotonic time at which the last short rest was performed
ShortRest = _Class:Create("ShortRest")

function ShortRest:Init()
  self.ShouldShortRestBeBlocked = false
  self.LastShortRestedTime = nil
  self.CooldownTimer = Config:getCfg().FEATURES.cooldown
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
  local currentTime = Ext.Utils.MonotonicTime() -- MonotonicTime returns time in milliseconds
  local cooldownDuration = self.CooldownTimer

  -- Cooldown is active if the time difference between the current time and the last short rested time is less than the cooldown duration.
  return (currentTime - self.LastShortRestedTime) < (cooldownDuration * 1000)
end

function ShortRest:DisableShortRest()
  Osi.SetShortRestAvailable(0)
  SRCDebug(1, "Short rest is now disabled.")
end

function ShortRest:EnableShortRest()
  Osi.SetShortRestAvailable(1)
  SRCDebug(1, "Short rest is now enabled.")
end

--- Handles the short rested event, applying the cooldown if necessary.
---@param character CHARACTER
function ShortRest:HandleShortRested(character)
  Osi.TimerLaunch("ShortRestCooldown", self.CooldownTimer * 1000)
  if self:IsCooldownActive() then
    SRCPrint(0, "Short rest is currently blocked due to cooldown.")
  else
    SRCDebug(1, "Short rest is not on cooldown. Proceeding with short rest.")
    self.LastShortRestedTime = Ext.Utils.MonotonicTime()
    self:DisableShortRest()
  end
end

return ShortRest
